# frozen_string_literal: true

require "rails_helper"

module Decidim
  describe ApplicationController, type: :controller do
    let(:default_locale) { "ca" }
    let(:alt_locale) { "es" }
    let(:available_locales) { %w(en ca oc es) }
    let(:organization) { create(:organization, default_locale: default_locale) }

    before do
      allow(Decidim).to receive(:default_locale).and_return default_locale
      allow(Decidim).to receive(:available_locales).and_return available_locales
      allow(I18n.config).to receive(:enforce_available_locales).and_return(false)
    end

    describe "no locale is passed" do
      it "detected locale is empty" do
        expect(controller.detect_locale.to_s).to eq(default_locale)
      end

      it "application uses default language" do
        controller.switch_locale do
          expect(I18n.locale.to_s).to eq(default_locale)
        end
      end
    end

    describe "request with GET locale parameter" do
      before do
        request.headers["Accept-Language"] = "ca-ES"
        controller.params[:locale] = "es"
      end

      it "locale matches GET language" do
        expect(controller.detect_locale.to_s).to eq("es")
      end
    end

    describe "request with GET invalid locale parameter" do
      before do
        request.headers["Accept-Language"] = "ca-ES"
        controller.params[:locale] = "foo"
      end

      it "application uses default locale" do
        controller.switch_locale do
          expect(I18n.locale.to_s).to eq(default_locale)
        end
      end
    end

    describe "request with session defined language" do
      before do
        controller.session[:user_locale] = "ca"
      end

      it "application uses session language" do
        controller.switch_locale do
          expect(I18n.locale.to_s).to eq("ca")
        end
      end
    end

    describe "request with user session" do
      let(:user) { create(:user, :confirmed, locale: "es", organization: organization) }

      before do
        allow(controller).to receive(:current_user) { user }
        controller.session[:user_locale] = "es"
      end

      it "application uses user language" do
        controller.switch_locale do
          expect(I18n.locale.to_s).to eq("es")
        end
      end
    end
  end
end
