# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../support/pdf_security_helper"

describe PdfSecurity::Inspector do
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
end
