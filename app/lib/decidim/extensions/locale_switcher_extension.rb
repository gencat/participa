# frozen_string_literal: true

module Decidim
  module Extensions
    module LocaleSwitcherExtension
      def detect_locale
        if params[:locale].present?
          params[:locale]
        elsif session[:user_locale].present?
          session[:user_locale]
        else
          "ca"
        end
      end
    end
  end
end
