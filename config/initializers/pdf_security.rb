# frozen_string_literal: true

Rails.application.config.x.pdf_security = {
  max_bytes: Integer(ENV.fetch("PDF_SECURITY_MAX_BYTES", 10.megabytes.to_s)),
  timeout: Integer(ENV.fetch("PDF_SECURITY_TIMEOUT", "5")),
  memory_bytes: Integer(ENV.fetch("PDF_SECURITY_MEMORY_BYTES", 512.megabytes.to_s)),
  max_pages: Integer(ENV.fetch("PDF_SECURITY_MAX_PAGES", "1000")),
  max_objects: Integer(ENV.fetch("PDF_SECURITY_MAX_OBJECTS", "100000")),
  max_revisions: Integer(ENV.fetch("PDF_SECURITY_MAX_REVISIONS", "50")),
  max_stream_bytes: Integer(ENV.fetch("PDF_SECURITY_MAX_STREAM_BYTES", 20.megabytes.to_s)),
  max_concurrency: Integer(ENV.fetch("PDF_SECURITY_MAX_CONCURRENCY", "8"))
}.freeze
