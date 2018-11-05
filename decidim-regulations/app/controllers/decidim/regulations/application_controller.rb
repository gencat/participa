module Decidim
  module Regulations
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
