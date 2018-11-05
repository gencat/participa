module Decidim
  module Selectable
    module News
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
