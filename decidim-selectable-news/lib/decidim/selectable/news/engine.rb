module Decidim
  module Selectable
    module News
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Selectable::News


        initializer "decidim_selectable_news.append_routes", before: :load_config_initializers do |app|
          Rails.application.routes.append do
            mount Decidim::Selectable::News::Engine => "/"
          end
        end

      end
    end
  end
end
