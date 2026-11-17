# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SEO metadata", type: :request do
  let!(:organization) { create(:organization) }

  before do
    host! organization.host
  end

  it "renders a canonical using Decidim's metadata URL on allowed pages" do
    get "/"

    document = Nokogiri::HTML(response.body)
    canonical_links = document.css('link[rel="canonical"]')

    expect(response.media_type).to eq("text/html")
    expect(canonical_links.size).to eq(1)
    expect(canonical_links.first["href"]).to eq(document.at_css('meta[property="og:url"]')["content"])
    expect(document.at_css('meta[name="robots"]')).to be_nil
  end

  it "adds noindex and omits the canonical on disallowed paths" do
    user = create(:user, :confirmed, organization:)

    get "/profiles/#{user.nickname}", params: { page: 2 }
    follow_redirect!

    document = Nokogiri::HTML(response.body)

    expect(response.media_type).to eq("text/html")
    expect(document.at_css('meta[name="robots"]')["content"]).to eq("noindex")
    expect(document.at_css('link[rel="canonical"]')).to be_nil
  end
end
