# frozen_string_literal: true

module Decidim
  module Recaptcha
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
