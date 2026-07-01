# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe CreateRegistration do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:name) { "Username" }
      let(:email) { "user@example.org" }
      let(:password) { "Y1fERVzL2F" }
      let(:tos_agreement) { "1" }
      let(:newsletter) { "1" }
      let(:current_locale) { "es" }

      let(:form_params) do
        {
          "user" => {
            "name" => name,
            "email" => email,
            "password" => password,
            "tos_agreement" => tos_agreement,
            "newsletter_at" => newsletter
          }
        }
      end
      let(:form) do
        RegistrationForm.from_params(
          form_params,
          current_locale:
        ).with_context(
          current_organization: organization
        )
      end
      let(:command) { described_class.new(form) }

      context "when recaptcha passes" do
        before do
          allow(command).to receive(:verify_recaptcha).and_return(true)
        end

        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "creates a new user" do
          expect { command.call }.to change(User, :count).by(1)
        end
      end

      context "when recaptcha fails" do
        before do
          allow(command).to receive(:verify_recaptcha).and_return(false)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "does not create a user" do
          expect { command.call }.not_to change(User, :count)
        end

        it "adds a recaptcha error to the form" do
          command.call
          expect(form.errors[:recaptcha]).to be_present
        end
      end
    end
  end
end
