# frozen_string_literal: true

require "spec_helper"

def fill_registration_form(
  name: "Nikola Tesla",
  email: "nikola.tesla@example.org",
  password: "sekritpass123"
)
  fill_in :registration_user_name, with: name
  fill_in :registration_user_email, with: email
  fill_in :registration_user_password, with: password
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
      it "renders the hidden recaptcha input" do
        expect(page).to have_css("#g-recaptcha-response-data-registration", visible: :hidden)
      end
    end

    context "when recaptcha passes" do
      before do
        allow_any_instance_of(Decidim::CreateRegistration).to receive(:verify_recaptcha).and_return(true)
      end

      it "signs up successfully" do
        fill_registration_form
        page.check("registration_user_tos_agreement")
        page.check("registration_user_newsletter")
        within "form.new_user" do
          find("*[type=submit]").click
        end
        expect(page).to have_content("A message with a confirmation link has been sent to your email address.")
      end
    end

    context "when recaptcha fails" do
      before do
        allow_any_instance_of(Decidim::CreateRegistration).to receive(:verify_recaptcha).and_return(false)
      end

      it "does not sign up the user and shows an error" do
        fill_registration_form
        page.check("registration_user_tos_agreement")
        page.check("registration_user_newsletter")
        within "form.new_user" do
          find("*[type=submit]").click
        end
        expect(page).to have_no_content("A message with a confirmation link has been sent to your email address.")
        expect(Decidim::User.where(email: "nikola.tesla@example.org")).not_to exist
      end
    end
  end
end
