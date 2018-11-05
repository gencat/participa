
module Decidim
  module Department
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Department

      initializer "decidim_department.inject_abilities_to_user" do |_app|
        Decidim.configure do |config|
          config.abilities += ["Decidim::Department::Abilities::AdminUser"]
        end
      end

      # Tested on 6.0.0 pre gem. Uncomment then
      initializer "decidim_department.inject_abilities_to_admin_user" do |_app|
        Decidim.configure do |config|
          config.admin_abilities += ["Decidim::Department::Abilities::Admin::AdminAbility"]
        end
      end

      initializer "decidim_department.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Department::Engine => "/"
        end
      end

    end
  end
end