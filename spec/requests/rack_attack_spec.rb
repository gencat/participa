require "rails_helper"

RSpec.describe "Rack::Attack", type: :request do
  # Include time helpers to allow use to use travel_to
  # within RSpec
  include ActiveSupport::Testing::TimeHelpers
  before do
    # Enable Rack::Attack for this test
    ENV["RACK_ATTACK"] = "true"
    Rack::Attack.enabled = true
    Rack::Attack.reset!
  end

  after do
    # Disable Rack::Attack for future tests so it doesn't
    # interfere with the rest of our tests
    Rack::Attack.enabled = false
  end

  describe "GET homepage" do
    let!(:organization) do
      create(
        :organization,
        name: "Participa Gencat",
        default_locale: :ca,
        available_locales: [:ca, :en, :es],
        host: "localhost"
      )
    end

    # Set the headers, if you'd blocking specific IPs you can change
    # this programmatically.
    let(:headers) { { "HTTP_X_FORWARDED_FOR" => "1.2.3.4" } }
    let(:root_url) { "http://localhost" }

    it "successful for 10 requests, then blocks the user nicely" do
      30.times do
        get root_url, params: {}, headers: headers
        expect(response).to have_http_status(:success)
      end
      get root_url, params: {}, headers: headers
      expect(response.body).to include("Retry later")
      expect(response).to have_http_status(:too_many_requests)
      travel_to(10.minutes.from_now) do
        get root_url, params: {}, headers: headers
        expect(response).to have_http_status(:success)
      end
    end
  end
end
