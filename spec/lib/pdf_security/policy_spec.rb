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

  it "accepts page transparency groups whether direct or indirect" do
    [false, true].each do |indirect|
      document = HexaPDF::Document.new
      group = { S: :Transparency, CS: :DeviceRGB, I: true }
      document.pages.add[:Group] = indirect ? document.add(group) : group

      expect(inspect_bytes(document.write_to_string)).to include(status: "clean", reasons: [])
    end
  end

  it "rejects a transparency group reused as an action" do
    document = HexaPDF::Document.new
    group = document.add({ S: :Transparency, CS: :DeviceRGB })
    page = document.pages.add
    page[:Group] = group
    page[:Annots] = [document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10], A: group })]

    expect(inspect_bytes(document.write_to_string)[:reasons]).to include("prohibited_action")
  end

  it "accepts passive page labels, output intents, and XObject transparency groups" do
    document = HexaPDF::Document.new
    page = document.pages.add
    label = document.add({ S: :r })
    intent = document.add({ Type: :OutputIntent, S: :GTS_PDFA1, OutputConditionIdentifier: "sRGB" })
    form = document.add({ Type: :XObject, Subtype: :Form, BBox: [0, 0, 10, 10],
                          Group: { S: :Transparency, CS: :DeviceRGB } }, stream: "")
    document.catalog[:PageLabels] = { Nums: [0, label] }
    document.catalog[:OutputIntents] = [intent]
    page[:Resources] = { XObject: { Fm1: form } }

    expect(inspect_bytes(document.write_to_string)).to include(status: "clean", reasons: [])
  end

  it "rejects prohibited actions in a direct Next array" do
    document = HexaPDF::Document.new
    document.pages.add
    document.catalog[:OpenAction] = { S: :GoTo, D: [0, :Fit], Next: [{ S: :JavaScript, JS: "app.alert(1)" }] }

    expect(inspect_bytes(document.write_to_string)).to include(status: "prohibited", reasons: include("javascript"))
  end

  it "rejects prohibited indirect action chains in compressed object streams" do
    document = HexaPDF::Document.new
    page = document.pages.add
    action = document.add({ S: :Launch, F: "example" })
    page[:Annots] = [document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10],
                                    A: { S: :GoTo, D: [0, :Fit], Next: [action] } })]
    document.task(:optimize, object_streams: :generate, xref_streams: :generate)

    expect(inspect_bytes(document.write_to_string)).to include(status: "prohibited", reasons: include("prohibited_action"))
  end

  it "rejects actions in older incremental revisions" do
    document = HexaPDF::Document.new
    page = document.pages.add
    page[:Annots] = [document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10],
                                    A: { S: :Launch, F: "example" } })]
    source = StringIO.new(document.write_to_string)
    updated = HexaPDF::Document.new(io: source)
    updated.pages[0][:Annots] = []
    output = StringIO.new
    updated.write(output, incremental: true)

    expect(inspect_bytes(output.string)).to include(status: "prohibited", reasons: include("prohibited_action"))
  end

  it "resolves actions against the revision in which they were referenced" do
    document = HexaPDF::Document.new
    page = document.pages.add
    action = document.add({ S: :UnknownAction })
    page[:Annots] = [document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10], A: action })]
    source = StringIO.new(document.write_to_string)
    updated = HexaPDF::Document.new(io: source)
    updated.object(action.oid).value.replace({ S: :GoTo, D: [0, :Fit] })
    output = StringIO.new
    updated.write(output, incremental: true)

    expect(inspect_bytes(output.string)).to include(status: "prohibited", reasons: include("prohibited_action"))
  end

  it "detects actions in outline items without confusing outline links with action chains" do
    document = HexaPDF::Document.new
    document.pages.add
    item = document.add({ Title: "Example", A: { S: :Launch, F: "example" } })
    document.catalog[:Outlines] = document.add({ Type: :Outlines, First: item, Last: item, Count: 1 })

    expect(inspect_bytes(document.write_to_string)).to include(status: "prohibited", reasons: include("prohibited_action"))
  end

  it "accepts passive signed PDFs without changing their bytes" do
    key = OpenSSL::PKey::RSA.new(2048)
    certificate = OpenSSL::X509::Certificate.new
    certificate.version = 2
    certificate.serial = 1
    certificate.subject = certificate.issuer = OpenSSL::X509::Name.parse("/CN=PDF test")
    certificate.public_key = key.public_key
    certificate.not_before = Time.current - 60
    certificate.not_after = Time.current + 3600
    certificate.sign(key, OpenSSL::Digest.new("SHA256"))
    document = HexaPDF::Document.new
    document.pages.add
    output = StringIO.new
    document.sign(output, certificate:, key:)
    bytes = output.string
    digest = Digest::SHA256.hexdigest(bytes)

    expect(inspect_bytes(bytes)).to include(status: "clean", signed: true)
    expect(Digest::SHA256.hexdigest(bytes)).to eq(digest)
  end

  it "terminates on cyclic action chains and still inspects each action" do
    document = HexaPDF::Document.new
    page = document.pages.add
    action = document.add({ S: :GoTo, D: [0, :Fit] })
    action[:Next] = [action, { S: :Launch, F: "example" }]
    page[:Annots] = [document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10], A: action })]

    expect(inspect_bytes(document.write_to_string)).to include(status: "prohibited", reasons: include("prohibited_action"))
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
    document = HexaPDF::Document.new
    page = document.pages.add
    page[:Annots] = [
      document.add({ Type: :Annot, Subtype: :Link, Rect: [0, 0, 10, 10],
                     A: { S: :URI, URI: "http://example.org/path" } }),
      document.add({ Type: :Annot, Subtype: :Link, Rect: [10, 0, 20, 10],
                     A: { S: :URI, URI: "HTTPS://example.org/path" } })
    ]

    expect(inspect_bytes(document.write_to_string)).to include(status: "clean", reasons: [])
  end

  it "rejects documents exceeding the object limit" do
    limits["max_objects"] = 1

    expect(inspect_bytes(generated_pdf)).to include(status: "uninspectable", reasons: ["too_many_objects"])
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
