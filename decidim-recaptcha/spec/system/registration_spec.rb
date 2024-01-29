# frozen_string_literal: true

require "spec_helper"

describe "Registration", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)

    Recaptcha.configure do |config|
      config.site_key = "0000000000000000000000000000000000000000"
      config.secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    end

    visit decidim.new_user_registration_path
  end

  context "when signing up" do
    describe "v3 recaptcha" do
      it "renders input" do
        expect(page).to have_css("#g-recaptcha-response-data-registration", visible: :hidden)
      end
    end
  end
end
