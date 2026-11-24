# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require "csv"
require_relative "../support/pdf_security_helper"

describe "pdf_security:report" do
  let(:output_directory) { Dir.mktmpdir("pdf-security-report") }
  let(:output_path) { File.join(output_directory, "report.csv") }
  let!(:pdf_attachment) do
    blob = upload_pdf(generated_pdf)
    create(:attachment, file: blob.signed_id, content_type: "application/pdf")
  end
  let!(:image_attachment) { create(:attachment, :with_image) }

  before do
    ENV["OUTPUT"] = output_path
    ENV["START_ID"] = "1"
    FileUtils.rm_f(Rails.root.join("tmp/pdf_security_report.state"))
    Rake::Task["pdf_security:report"].reenable
  end

  after do
    ENV.delete("OUTPUT")
    ENV.delete("START_ID")
    ENV.delete("LIMIT")
    FileUtils.rm_rf(output_directory)
    FileUtils.rm_f(Rails.root.join("tmp/pdf_security_report.state"))
  end

  it "writes a read-only CSV report for PDFs and ignores non-PDF files" do
    updated_at = pdf_attachment.reload.updated_at
    count = Decidim::Attachment.count

    Rake::Task["pdf_security:report"].invoke

    rows = CSV.read(output_path, headers: true)
    expect(rows.size).to eq(1)
    expect(rows.first["attachment_id"]).to eq(pdf_attachment.id.to_s)
    expect(rows.first["status"]).to eq("clean")
    expect(Decidim::Attachment.count).to eq(count)
    expect(pdf_attachment.reload.updated_at).to eq(updated_at)
    expect(Decidim::Attachment.exists?(image_attachment.id)).to be(true)
  end

  it "resumes the default report file from the saved attachment ID" do
    second_pdf = upload_pdf(generated_pdf)
    create(:attachment, file: second_pdf.signed_id, content_type: "application/pdf")
    ENV["LIMIT"] = "1"

    Rake::Task["pdf_security:report"].invoke

    expect(CSV.read(output_path, headers: true).size).to eq(1)

    ENV.delete("LIMIT")
    ENV.delete("OUTPUT")
    ENV.delete("START_ID")
    Rake::Task["pdf_security:report"].reenable
    Rake::Task["pdf_security:report"].invoke

    expect(CSV.read(output_path, headers: true).size).to eq(2)
  end
end
