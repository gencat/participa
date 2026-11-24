# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../../support/pdf_security_helper"

describe Decidim::ParticipatoryProcesses::ParticipatoryProcessImporter do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization:) }
  let(:process) { create(:participatory_process, organization:) }
  let(:importer) { described_class.new(organization, user) }
  let(:url) { "http://example.com/unsafe.pdf" }
  let(:attachments) do
    {
      "files" => [
        {
          "title" => { "en" => "Unsafe PDF" },
          "description" => { "en" => "Description" },
          "weight" => 1,
          "remote_file_url" => url
        }
      ],
      "attachment_collections" => []
    }
  end

  before do
    importer.instance_variable_set(:@imported_process, process)
    stub_request(:head, url).to_return(status: 200, headers: { "Content-Type" => "application/pdf" })
    stub_request(:get, url).to_return(status: 200, body: generated_pdf(action: { S: :JavaScript, JS: "app.alert(1)" }))
  end

  it "skips a rejected PDF, warns, and continues the process import" do
    expect { importer.import_folders_and_attachments(attachments) }.not_to change(Decidim::Attachment, :count)

    expect(importer.warnings).to include(a_string_matching(/Unsafe PDF/))
    expect(process.reload).to be_persisted
  end
end
