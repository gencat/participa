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
          load c
        end
      end

      initializer "decidim_recaptcha.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
