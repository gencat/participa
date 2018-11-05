module Decidim
  module Department
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
