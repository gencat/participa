# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module TopComments
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::TopComments

      initializer "decidim_top_comments.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      # make decorators autoload in development env
      config.autoload_paths << File.join(
        Decidim::TopComments::Engine.root, "app", "decorators", "{**}"
      )

      initializer "decidim_top_comments.register_icons" do
        Decidim.icons.register(name: "thumb-up", icon: "thumb-up", category: "", description: "", engine: :top_comments)
        Decidim.icons.register(name: "thumb-down", icon: "thumb-down", category: "", description: "", engine: :top_comments)
      end

      # make decorators available to applications that use this Engine
      config.to_prepare do
        Dir.glob("#{Decidim::TopComments::Engine.root}/app/decorators/**/*_decorator*.rb").each do |c|
          load c
        end
      end
    end
  end
end
