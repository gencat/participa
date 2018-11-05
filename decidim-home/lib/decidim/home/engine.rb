module Decidim
  module Home
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Home

      initializer "decidim_home.assets" do |app|
        app.config.assets.precompile += %w(logo_generalitat_gris.png)
        app.config.assets.precompile += %w(logo_generalitat_white.png)
      end

    end
  end
end
