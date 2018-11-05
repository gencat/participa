module Decidim
  module Espais
    module Estables
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    end
  end
end
