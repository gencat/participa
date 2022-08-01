# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Home
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Home

      config.to_prepare do
        # activate Decidim LayoutHelper for the overriden views
        ActiveSupport.on_load :action_controller do
          helper Decidim::LayoutHelper if respond_to?(:helper)
        end
      end

      initializer "decidim_home.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Home::Engine.root}/app/cells")
      end

      initializer "decidim_home.content_blocks" do
        Decidim.content_blocks.register(:homepage, :feder) do |content_block|
          content_block.cell = "decidim/home/content_blocks/feder"
          content_block.public_name_key = "decidim.content_blocks.feder.name"
        end
      end

      initializer "decidim_home.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
