module Decidim
  module Theme
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Theme

      initializer "decidim_theme.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Theme::Engine => "/"
        end
      end
    end
  end
end
