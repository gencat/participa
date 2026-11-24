# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../support/pdf_security_helper"

RSpec.describe "PDF downloads", type: :request do
  let(:pdf_blob) { upload_pdf("%PDF-1.7\n%%EOF") }

  def blob_path(blob, disposition: nil)
    Rails.application.routes.url_helpers.rails_blob_path(blob, disposition:, only_path: true)
  end

  it "forces PDF downloads even when inline disposition is requested" do
    get blob_path(pdf_blob, disposition: "inline")

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to start_with("attachment")
    expect(response.headers["Content-Type"]).to include("application/pdf")
    expect(response.headers["X-Content-Type-Options"]).to eq("nosniff")
  end

  it "forces partial PDF responses to download" do
    get blob_path(pdf_blob), headers: { "Range" => "bytes=0-0" }

    expect(response).to have_http_status(:partial_content)
    expect(response.headers["Content-Disposition"]).to start_with("attachment")
    expect(response.headers["Content-Range"]).to start_with("bytes 0-0/")
  end

  it "keeps images inline" do
    image = Decidim::Dev.test_file("city.jpeg", "image/jpeg")
    blob = ActiveStorage::Blob.create_and_upload!(
      io: image,
      filename: "city.jpeg",
      content_type: "image/jpeg"
    )
    get blob_path(blob)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to start_with("inline")
  end
end
