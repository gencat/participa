module Decidim
  module Theme
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Theme

      initializer "decidim_theme.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += ["Decidim::Theme::Abilities::AdminUser"]
        end
      end

      # Tested on 6.0.0 pre gem. Uncomment then
      initializer "decidim_theme.inject_abilities_to_admin_user" do |_app|
        Decidim.configure do |config|
          config.admin_abilities += ["Decidim::Theme::Abilities::Admin::AdminAbility"]
        end
      end

      initializer "decidim_theme.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Theme::Engine => "/"
        end
      end

    end
  end
end
