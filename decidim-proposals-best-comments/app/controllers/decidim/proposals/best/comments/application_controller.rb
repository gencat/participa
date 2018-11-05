module Decidim
  module Proposals
    module Best
      module Comments
        class ApplicationController < ActionController::Base
          protect_from_forgery with: :exception
        end
      end
    end
  end
end
