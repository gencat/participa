# frozen_string_literal: true

require "hexapdf"
require "stringio"
require "tempfile"

module PdfSecurityHelper
  def generated_pdf(action: nil, extra_catalog_entries: {})
    document = HexaPDF::Document.new
    document.pages.add
    extra_catalog_entries.each { |key, value| document.catalog[key] = value }
    document.catalog[:OpenAction] = action if action
    document.write_to_string
  end

  def upload_pdf(bytes, filename: "test.pdf", content_type: "application/pdf")
    ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(bytes),
      filename:,
      content_type:
    )
  end
end

RSpec.configure do |config|
  config.include PdfSecurityHelper
end
