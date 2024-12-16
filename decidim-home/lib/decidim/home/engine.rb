# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Home
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Home

      initializer "decidim_home.helpers" do
        # activate Decidim LayoutHelper for the overriden views
        ::Decidim::Admin::ApplicationController.helper ::Decidim::LayoutHelper
        ::Decidim::ApplicationController.helper ::Decidim::LayoutHelper
      end

      initializer "decidim_home.register_icons" do
        Decidim.icons.register(name: "icon-menu", icon: "icon-menu", category: "", description: "", engine: :home)
      end

      initializer "decidim_home.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Home::Engine.root}/app/cells")
      end

      initializer "decidim_home.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
