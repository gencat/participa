# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../support/pdf_security_helper"

describe PdfSecurity::Inspector do
  let(:limits) { Rails.application.config.x.pdf_security.to_h }

  it "inspects the copied bytes in a subprocess and returns their digest" do
    bytes = generated_pdf
    source = StringIO.new(bytes)

    result = described_class.call(source)

    expect(result.status).to eq(:clean)
    expect(result.sha256).to eq(Digest::SHA256.hexdigest(bytes))
    expect(source.pos).to eq(0)
  end

  it "rejects inputs over the configured size before invoking the parser" do
    result = described_class.call(
      StringIO.new("%PDF-#{"x" * 100}"),
      limits: Rails.application.config.x.pdf_security.to_h.merge(max_bytes: 10)
    )

    expect(result.status).to eq(:uninspectable)
    expect(result.reasons).to include(:too_large)
  end

  it "spawns the parser with a clean environment and resource limits" do
    inspector = described_class.new(limits)
    reader, writer = IO.pipe
    spawn_arguments = nil
    allow(inspector).to receive(:dependency_load_paths).and_return(["/gems"])
    allow(Process).to receive(:spawn) do |*command, **options|
      spawn_arguments = [command, options]
      123
    end

    inspector.send(:spawn_inspector, "/tmp/input.pdf", "/tmp", writer)

    command, options = spawn_arguments
    expect(command).to include(RbConfig.ruby, "--disable-gems", "-I/gems")
    expect(options).to include(
      unsetenv_others: true,
      chdir: "/tmp",
      close_others: true,
      pgroup: true,
      rlimit_as: [limits.fetch(:memory_bytes), limits.fetch(:memory_bytes)],
      rlimit_cpu: [limits.fetch(:timeout), limits.fetch(:timeout) + 1],
      rlimit_fsize: [0, 0],
      rlimit_nofile: [16, 16],
      rlimit_core: [0, 0]
    )
    expect(options).not_to have_key(:uid)
    expect(options).not_to have_key(:gid)
  ensure
    reader&.close
    writer&.close
  end

  it "removes temporary files after successful inspection" do
    inspector = described_class.new(limits)
    temporary_path = nil
    temporary_directory = nil
    allow(inspector).to receive(:inspect_in_subprocess) do |path, directory|
      temporary_path = path
      temporary_directory = directory
      expect(File).to exist(path)
      { "status" => "clean", "reasons" => [], "signed" => false }
    end

    result = inspector.call(StringIO.new(generated_pdf))

    expect(result.status).to eq(:clean)
    expect(File).not_to exist(temporary_path)
    expect(Dir).not_to exist(temporary_directory)
  end

  it "removes temporary files after an inspection exception" do
    inspector = described_class.new(limits)
    temporary_path = nil
    temporary_directory = nil
    allow(inspector).to receive(:inspect_in_subprocess) do |path, directory|
      temporary_path = path
      temporary_directory = directory
      raise IOError, "simulated inspection failure"
    end

    result = inspector.call(StringIO.new(generated_pdf))

    expect(result.status).to eq(:uninspectable)
    expect(result.reasons).to include(:internal_error)
    expect(File).not_to exist(temporary_path)
    expect(Dir).not_to exist(temporary_directory)
  end

  it "terminates and reaps a subprocess when its wall-clock deadline expires" do
    inspector = described_class.new(limits.merge(timeout: 1))
    child_pid = nil
    allow(inspector).to receive(:spawn_inspector) do |_path, _directory, writer|
      child_pid = Process.spawn(RbConfig.ruby, "-e", "sleep 10", out: writer, pgroup: true)
    end

    result = inspector.call(StringIO.new(generated_pdf))

    expect(result.status).to eq(:uninspectable)
    expect(result.reasons).to include(:timeout)
    expect { Process.waitpid(child_pid, Process::WNOHANG) }.to raise_error(Errno::ECHILD)
  end

  it "terminates a subprocess that exceeds the output limit" do
    inspector = described_class.new(limits)
    child_pid = nil
    allow(inspector).to receive(:spawn_inspector) do |_path, _directory, writer|
      child_pid = Process.spawn(
        RbConfig.ruby,
        "-e",
        "STDOUT.write('x' * #{described_class::OUTPUT_LIMIT + 1})",
        out: writer,
        pgroup: true
      )
    end

    result = inspector.call(StringIO.new(generated_pdf))

    expect(result.status).to eq(:uninspectable)
    expect(result.reasons).to include(:internal_error)
    expect { Process.waitpid(child_pid, Process::WNOHANG) }.to raise_error(Errno::ECHILD)
  end
end
