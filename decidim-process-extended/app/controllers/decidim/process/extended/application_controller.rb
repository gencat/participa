module Decidim
  module Process
    module Extended
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
        helper Decidim::SanitizeHelper
      end
    end
  end
end
