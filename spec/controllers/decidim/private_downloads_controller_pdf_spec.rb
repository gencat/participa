# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

describe "Decidim private PDF downloads", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:process) { create(:participatory_process, :private, :published, organization:) }
  let(:member) { create(:participatory_space_private_user, :published, user:, privatable_to: process) }
  let(:attachment) { create(:attachment, :with_pdf, attached_to: process) }
  let(:token) { Decidim::PrivateDownload.for(attachment, attachment_name: :file).token }

  before do
    host! organization.host
    sign_in user
    member
  end

  it "forces PDF downloads and sends nosniff for private attachments" do
    path = Decidim::Core::Engine.routes.url_helpers.private_download_path(token, locale: I18n.default_locale)
    get path

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Disposition"]).to start_with("attachment")
    expect(response.headers["Content-Type"]).to include("application/pdf")
    expect(response.headers["X-Content-Type-Options"]).to eq("nosniff")
  end
end
