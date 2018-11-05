module Decidim
  module Meetings
    module Extended
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Meetings::Extended

        initializer "decidim_meetings_extended.append_routes", before: :load_config_initializers do |app|
          Rails.application.routes.append do
            mount Decidim::Meetings::Extended::Engine => "/"
          end
        end

      end
    end
  end
end
