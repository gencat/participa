# frozen_string_literal: true

require "rails_helper"

describe Decidim::OpenDataManifestsDecorator do
  let(:organization) { create(:organization) }

  describe "Decidim.open_data_manifests" do
    let(:included_names) { Decidim.open_data_manifests.select(&:include_in_open_data).map(&:name) }

    it "excludes metrics from the open data" do
      expect(included_names).not_to include(:metrics)
    end

    it "keeps the rest of core manifests" do
      expect(included_names).to include(:moderated_users, :moderations, :users, :user_groups, :taxonomies)
    end
  end

  describe "open data page", type: :request do
    it "does not show the metrics download link" do
      get decidim.open_data_path, headers: { "HOST" => organization.host }

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include(decidim.open_data_download_resource_path("metrics"))
      expect(response.body).to include(decidim.open_data_download_resource_path("users"))
    end
  end
end
