# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../support/pdf_security_helper"

describe Decidim::Attachment do
  let(:passive_pdf) { generated_pdf }
  let(:forbidden_pdf) { generated_pdf(action: { S: :JavaScript, JS: "app.alert(1)" }) }
  let(:disguised_pdf_blob) { upload_pdf(forbidden_pdf, filename: "report.txt", content_type: "text/plain") }

  it "accepts a passive PDF" do
    attachment = build(:attachment, file: upload_pdf(passive_pdf).signed_id, content_type: "application/pdf")

    expect(attachment).to be_valid
  end

  it "rejects a PDF with prohibited actions" do
    blob = upload_pdf(forbidden_pdf)
    attachment = build(:attachment, file: blob.signed_id, content_type: "application/pdf")

    expect(attachment).not_to be_valid
    expect(attachment.errors.details[:file].map { |error| error[:error] }).to include(:pdf_prohibited_content)
  end

  it "rejects a declared PDF that cannot be inspected" do
    attachment = build(:attachment, file: upload_pdf("not a PDF").signed_id, content_type: "application/pdf")

    expect(attachment).not_to be_valid
    expect(attachment.errors.details[:file].map { |error| error[:error] }).to include(:pdf_uninspectable)
  end

  it "inspects PDF bytes even when the filename and MIME type disguise them" do
    attachment = build(:attachment, file: disguised_pdf_blob.signed_id, content_type: "text/plain")

    expect(attachment).not_to be_valid
    expect(attachment.errors.details[:file].map { |error| error[:error] }).to include(:pdf_prohibited_content)
    expect(disguised_pdf_blob.reload.content_type).to eq("application/pdf")
  end

  it "does not inspect non-PDF attachments" do
    attachment = build(:attachment, :with_image)

    expect(PdfSecurity::Inspector).not_to receive(:call)
    expect(attachment).to be_valid
  end
end
