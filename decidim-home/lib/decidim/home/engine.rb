# frozen_string_literal: true

require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Home
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Home

      initializer "decidim_home.assets" do |app|
        app.config.assets.precompile += %w(logo_generalitat_white.png feder.png)
      end

      initializer "decidim_home.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Home::Engine.root}/app/cells")
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
    end
  end
end
