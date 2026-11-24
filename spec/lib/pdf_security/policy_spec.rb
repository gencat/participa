# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../support/pdf_security_helper"
require_relative "../../../lib/pdf_security/policy"

describe PdfSecurity::Policy do
  let(:limits) do
    {
      "max_bytes" => 10.megabytes,
      "max_pages" => 1000,
      "max_objects" => 100_000,
      "max_revisions" => 50,
      "max_stream_bytes" => 20.megabytes
    }
  end

  def inspect_bytes(bytes)
    Tempfile.create(["pdf-policy", ".pdf"]) do |file|
      file.binmode
      file.write(bytes)
      file.flush
      described_class.new(file.path, limits).inspect
    end
  end

  it "accepts a passive PDF without changing it" do
    bytes = generated_pdf

    expect(inspect_bytes(bytes)).to include(status: "clean", reasons: [], signed: false)
  end

  it "rejects JavaScript actions" do
    bytes = generated_pdf(action: { S: :JavaScript, JS: "app.alert(1)" })

    result = inspect_bytes(bytes)
    expect(result[:status]).to eq("prohibited")
    expect(result[:reasons]).to include("javascript", "prohibited_action")
  end

  it "rejects unsupported action types" do
    bytes = generated_pdf(action: { S: :Launch, F: "example" })

    expect(inspect_bytes(bytes)[:reasons]).to include("prohibited_action")
  end

  it "rejects non-HTTP URI actions" do
    bytes = generated_pdf(action: { S: :URI, URI: "javascript:alert(1)" })

    expect(inspect_bytes(bytes)[:reasons]).to include("prohibited_action")
  end

  it "allows HTTP and HTTPS URI actions" do
    bytes = generated_pdf(
      extra_catalog_entries: {
        SafeHttpAction: { S: :URI, URI: "http://example.org/path" },
        SafeHttpsAction: { S: :URI, URI: "HTTPS://example.org/path" }
      }
    )

    expect(inspect_bytes(bytes)).to include(status: "clean", reasons: [])
  end

  it "rejects encrypted PDFs" do
    document = HexaPDF::Document.new
    document.pages.add
    document.encrypt(user_password: "secret", owner_password: "owner")

    expect(inspect_bytes(document.write_to_string)[:reasons]).to include("encrypted")
  end

  it "fails closed on a malformed PDF" do
    expect(inspect_bytes("%PDF-1.7\nnot a document")).to include(status: "uninspectable", reasons: ["malformed"])
  end
end
