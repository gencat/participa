module Decidim
  module Type
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Type

      initializer "decidim_type.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Type::Engine => "/"
        end
      end

      # make decorators autoload in development env
      config.autoload_paths << File.join(
        Decidim::Type::Engine.root, 'app', 'decorators', '{**}'
      )

      # make decorators available to applications that use this Engine
      config.to_prepare do
        Dir.glob(Decidim::Type::Engine.root + 'app/decorators/**/*_decorator*.rb').each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
