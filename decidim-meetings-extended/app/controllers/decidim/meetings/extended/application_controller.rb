module Decidim
  module Meetings
    module Extended
      class ApplicationController < Decidim::Meetings::ApplicationController
        protect_from_forgery with: :exception
      end
    end
  end
end
