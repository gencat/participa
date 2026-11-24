# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "rbconfig"
require "tempfile"
require "tmpdir"

module PdfSecurity
  Result = Struct.new(:status, :reasons, :sha256, :duration_ms, :signed, keyword_init: true)

  class Inspector
    OUTPUT_LIMIT = 64 * 1024
    CHUNK_SIZE = 64 * 1024
    SCRIPT_PATH = Rails.root.join("lib/pdf_security/inspect_cli.rb").to_s
    SEMAPHORE_MUTEX = Mutex.new

    class InspectorTimeout < StandardError; end

    class InspectorOutputLimit < StandardError; end

    class Semaphore
      def initialize(limit)
        @limit = limit
        @available = limit
        @mutex = Mutex.new
        @condition = ConditionVariable.new
      end

      def try_acquire?(timeout)
        deadline = monotonic_time + timeout
        @mutex.synchronize do
          while @available.zero?
            remaining = deadline - monotonic_time
            return false if remaining <= 0

            @condition.wait(@mutex, remaining)
          end
          @available -= 1
        end
        true
      end

      def release
        @mutex.synchronize do
          @available += 1
          @condition.signal
        end
      end

      private

      def monotonic_time
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end
    end

    class << self
      def call(io_or_path, limits: configuration)
        new(limits).call(io_or_path)
      end

      private

      def configuration
        Rails.application.config.x.pdf_security.to_h
      end
    end

    def initialize(limits)
      @limits = limits.transform_keys(&:to_sym)
      @semaphore = SEMAPHORE_MUTEX.synchronize do
        self.class.instance_variable_get(:@semaphore) ||
          self.class.instance_variable_set(:@semaphore, Semaphore.new(@limits.fetch(:max_concurrency)))
      end
    end

    def call(io_or_path)
      started_at = monotonic_time
      sha256 = nil
      status = nil
      reasons = []
      signed = false

      Dir.mktmpdir("pdfsec-") do |directory|
        File.chmod(0o700, directory)
        Tempfile.create(["upload-", ".pdf"], directory, mode: 0o600) do |tempfile|
          tempfile.binmode
          tempfile.chmod(0o600)
          sha256, size = copy_source(io_or_path, tempfile)
          @bytesize = size
          if size > @limits.fetch(:max_bytes)
            status = :uninspectable
            reasons = [:too_large]
          else
            @inspection_deadline = monotonic_time + @limits.fetch(:timeout)
          end
          if status.nil? && acquire_slot?
            begin
              tempfile.flush
              result = inspect_in_subprocess(tempfile.path, directory)
              status = result.fetch("status").to_sym
              reasons = result.fetch("reasons").map(&:to_sym)
              signed = result["signed"] == true
            ensure
              @semaphore.release
            end
          elsif status.nil?
            status = :uninspectable
            reasons = [:busy]
          end
        end
      end

      result = Result.new(
        status: status,
        reasons: reasons,
        sha256:,
        duration_ms: ((monotonic_time - started_at) * 1000).round,
        signed:
      )
      log_result(result)
      result
    rescue StandardError
      result = Result.new(
        status: :uninspectable,
        reasons: [:internal_error],
        sha256:,
        duration_ms: ((monotonic_time - started_at) * 1000).round,
        signed: false
      )
      log_result(result)
      result
    end

    private

    def copy_source(io_or_path, tempfile)
      digest = Digest::SHA256.new
      size = 0
      with_source(io_or_path) do |source|
        source.rewind if source.respond_to?(:rewind)
        while (chunk = source.read(CHUNK_SIZE))
          break if chunk.empty?

          size += chunk.bytesize
          return [nil, size] if size > @limits.fetch(:max_bytes)

          digest.update(chunk)
          tempfile.write(chunk)
        end
      ensure
        source.rewind if source.respond_to?(:rewind)
      end
      [digest.hexdigest, size]
    end

    def with_source(io_or_path, &block)
      if io_or_path.respond_to?(:read)
        block.call(io_or_path)
      elsif io_or_path.respond_to?(:to_path)
        File.open(io_or_path.to_path, "rb", &block)
      else
        File.open(io_or_path, "rb", &block)
      end
    end

    def acquire_slot?
      @semaphore.try_acquire?([@inspection_deadline - monotonic_time, 0].max)
    end

    def inspect_in_subprocess(path, directory)
      reader, writer = IO.pipe
      pid = spawn_inspector(path, directory, writer)
      writer.close
      output = read_subprocess_output(reader, pid)
      _, process_status = Process.wait2(pid)
      return failure_response("resource_limit") unless process_status.success?

      parse_subprocess_output(output)
    rescue InspectorTimeout
      failure_response("timeout")
    rescue InspectorOutputLimit, JSON::ParserError
      failure_response("internal_error")
    ensure
      reader&.close
      writer&.close
      if pid
        begin
          Process.wait(pid)
        rescue Errno::ECHILD
          nil
        end
      end
    end

    def read_subprocess_output(reader, pid)
      output = +""
      loop do
        remaining = @inspection_deadline - monotonic_time
        raise InspectorTimeout if remaining <= 0 || !reader.wait_readable(remaining)

        chunk = reader.read_nonblock(16 * 1024, exception: false)
        next if chunk == :wait_readable
        break if chunk.nil?

        output << chunk
        raise InspectorOutputLimit if output.bytesize > OUTPUT_LIMIT
      end
      output
    rescue InspectorTimeout, InspectorOutputLimit
      terminate_process(pid)
      raise
    end

    def parse_subprocess_output(output)
      JSON.parse(output)
    end

    def failure_response(reason)
      { "status" => "uninspectable", "reasons" => [reason] }
    end

    def spawn_inspector(path, directory, writer)
      load_paths = dependency_load_paths
      command = [
        RbConfig.ruby,
        "--disable-gems",
        "-I#{load_paths.join(File::PATH_SEPARATOR)}",
        SCRIPT_PATH,
        path,
        @limits.to_json
      ]
      Process.spawn(
        *command,
        unsetenv_others: true,
        in: File::NULL,
        out: writer,
        err: File::NULL,
        chdir: directory,
        close_others: true,
        pgroup: true,
        rlimit_as: [@limits.fetch(:memory_bytes), @limits.fetch(:memory_bytes)],
        rlimit_cpu: [@limits.fetch(:timeout), @limits.fetch(:timeout) + 1],
        rlimit_fsize: [0, 0],
        rlimit_nofile: [16, 16],
        rlimit_core: [0, 0]
      )
    end

    def dependency_load_paths
      specs = {}
      add_spec = lambda do |spec|
        return if specs.has_key?(spec.name)

        specs[spec.name] = spec
        spec.runtime_dependencies.each do |dependency|
          dependency_spec = Gem.loaded_specs[dependency.name]
          add_spec.call(dependency_spec) if dependency_spec
        end
      end
      add_spec.call(Gem.loaded_specs.fetch("hexapdf"))
      specs.values.flat_map(&:full_require_paths).uniq
    end

    def terminate_process(pid)
      Process.kill("KILL", -pid)
    rescue Errno::ESRCH
      nil
    ensure
      begin
        Process.wait(pid)
      rescue Errno::ECHILD
        nil
      end
    end

    def log_result(result)
      Rails.logger.info(
        "pdf_security status=#{result.status} reasons=#{result.reasons.join(",")} " \
        "sha256=#{result.sha256} bytes=#{@bytesize || "unknown"} " \
        "ms=#{result.duration_ms}"
      )
    end

    def monotonic_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
