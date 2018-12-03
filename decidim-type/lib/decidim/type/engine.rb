module Decidim
  module Type
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Type

      # initializer "decidim_type.inject_abilities_to_user" do |_app|
      #   Decidim.configure do |config|
      #     config.abilities += ["Decidim::Type::Abilities::AdminUser"]
      #   end
      # end
      #
      # # Tested on 6.0.0 pre gem. Uncomment then
      # initializer "decidim_type.inject_abilities_to_admin_user" do |_app|
      #   Decidim.configure do |config|
      #     config.admin_abilities += ["Decidim::Type::Abilities::Admin::AdminAbility"]
      #   end
      # end

      initializer "decidim_type.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Type::Engine => "/"
        end
      end
    end
  end
end
