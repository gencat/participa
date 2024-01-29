# frozen_string_literal: true

module Decidim
  module Recaptcha
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Recaptcha

      # make decorators autoload in development env
      config.autoload_paths << File.join(
        Decidim::Recaptcha::Engine.root, "app", "decorators", "{**}"
      )

      # make decorators available to applications that use this Engine
      config.to_prepare do
        Dir.glob(Decidim::Recaptcha::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
