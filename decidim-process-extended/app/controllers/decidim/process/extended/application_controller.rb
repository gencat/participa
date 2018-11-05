module Decidim
  module Process
    module Extended
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
