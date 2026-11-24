# frozen_string_literal: true

require "digest"

module PdfSecurity
  module AttachmentValidation
    extend ActiveSupport::Concern

    UPLOAD_HASH_CHUNK_SIZE = 64 * 1024

    FailureResult = Struct.new(:status, :reasons).new(:uninspectable, [:internal_error]).freeze

    included do
      validate :pdf_file_must_be_safe, if: -> { attachment_changes["file"].present? }
    end

    private

    def pdf_file_must_be_safe
      result = inspect_pdf_upload
      return unless result
      return if result.status == :clean

      error = result.status == :prohibited ? :pdf_prohibited_content : :pdf_uninspectable
      errors.add(:file, error)
    end

    def inspect_pdf_upload
      blob = file.blob
      attachable = attachment_changes["file"]&.attachable
      declared_pdf = pdf_upload_declared?(blob, attachable)
      with_pdf_upload_source(blob, attachable) do |source|
        detected_pdf = pdf_header?(source)
        next unless declared_pdf || detected_pdf

        cache_key = pdf_upload_sha256(source)
        next pdf_security_cache[cache_key] if pdf_security_cache.has_key?(cache_key)

        normalize_pdf_content_type(blob) if detected_pdf

        result = PdfSecurity::Inspector.call(source)
        pdf_security_cache[cache_key] = result
      end
    rescue StandardError
      Rails.logger.error("pdf_security status=uninspectable reasons=internal_error")
      FailureResult
    end

    def pdf_security_cache
      @pdf_security_cache ||= {}
    end

    def pdf_upload_declared?(blob, attachable)
      pdf_content_type?(blob&.content_type) ||
        pdf_filename?(blob&.filename) ||
        pdf_filename?(attachable_filename(attachable)) ||
        pdf_content_type?(attachable_content_type(attachable))
    end

    def normalize_pdf_content_type(blob)
      return unless blob && !pdf_content_type?(blob.content_type)

      if blob.persisted?
        blob.update!(content_type: "application/pdf")
      else
        blob.content_type = "application/pdf"
      end
    end

    def with_pdf_upload_source(blob, attachable, &)
      return blob.open(&) if blob&.persisted?

      source = pending_upload_source(attachable)
      yield_upload_source(source, &)
    end

    def pending_upload_source(attachable)
      return attachable[:io] || attachable["io"] if attachable.is_a?(Hash)
      return attachable.tempfile if attachable.respond_to?(:tempfile)

      attachable
    end

    def yield_upload_source(source, &block)
      return block.call(source) if source.respond_to?(:read)
      return File.open(source.to_path, "rb", &block) if source.respond_to?(:to_path)
      return File.open(source, "rb", &block) if source.is_a?(String)

      raise IOError, "PDF upload source is unavailable"
    end

    def pdf_header?(source)
      source.rewind if source.respond_to?(:rewind)
      source.read(1024).to_s.include?("%PDF-")
    ensure
      source.rewind if source.respond_to?(:rewind)
    end

    def pdf_upload_sha256(source)
      digest = Digest::SHA256.new
      size = 0
      while (chunk = source.read(UPLOAD_HASH_CHUNK_SIZE))
        break if chunk.empty?

        size += chunk.bytesize
        return :oversized if size > Rails.application.config.x.pdf_security.fetch(:max_bytes)

        digest.update(chunk)
      end
      digest.hexdigest
    ensure
      source.rewind if source.respond_to?(:rewind)
    end

    def pdf_content_type?(content_type)
      content_type.to_s.split(";", 2).first == "application/pdf"
    end

    def pdf_filename?(filename)
      filename.to_s.downcase.end_with?(".pdf")
    end

    def attachable_filename(attachable)
      return attachable.original_filename if attachable.respond_to?(:original_filename)
      return attachable.filename if attachable.respond_to?(:filename)

      attachable[:filename] || attachable["filename"] if attachable.is_a?(Hash)
    end

    def attachable_content_type(attachable)
      return attachable.content_type if attachable.respond_to?(:content_type)

      attachable[:content_type] || attachable["content_type"] if attachable.is_a?(Hash)
    end
  end
end
