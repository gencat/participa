module Decidim
  module Type
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Type

      initializer "decidim_type.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Type::Engine => "/"
        end
      end
    end
  end
end
