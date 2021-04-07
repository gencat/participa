# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module TopComments
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::TopComments

      # make decorators autoload in development env
      config.autoload_paths << File.join(
        Decidim::TopComments::Engine.root, "app", "decorators", "{**}"
      )

      # make decorators available to applications that use this Engine
      config.to_prepare do
        Dir.glob(Decidim::TopComments::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
