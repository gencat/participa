# frozen_string_literal: true

require "spec_helper"

def fill_registration_form(
  name: "Nikola Tesla",
  nickname: "the-greatest-genius-in-history",
  email: "nikola.tesla@example.org",
  password: "sekritpass123"
)
  fill_in :registration_user_name, with: name
  fill_in :registration_user_nickname, with: nickname
  fill_in :registration_user_email, with: email
  fill_in :registration_user_password, with: password
  fill_in :registration_user_password_confirmation, with: password
end

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

  describe "when signing up" do
    context "with v3 recaptcha" do
      it "renders input" do
        expect(page).to have_css("#g-recaptcha-response-data-registration", visible: :hidden)
      end
    end

    it "signing up successfully" do
      fill_registration_form
      page.check("registration_user_tos_agreement")
      page.check("registration_user_newsletter")
      within "form.new_user" do
        find("*[type=submit]").click
      end
      expect(page).to have_content("A message with a confirmation link has been sent to your email address.")
    end
  end
end
