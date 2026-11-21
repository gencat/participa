# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"

module Decidim
  module Process
    module Extended
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Process::Extended

        # make decorators autoload in development env
        config.autoload_paths << File.join(
          Decidim::Process::Extended::Engine.root, "app", "decorators", "{**}"
        )

        # make decorators available to applications that use this Engine
        config.to_prepare do
          Dir.glob("#{Decidim::Process::Extended::Engine.root}/app/decorators/**/*_decorator*.rb").each do |c|
            load c
          end
        end

        # activate Decidim LayoutHelper for the overriden views
        initializer "decidim_process_extended.helpers" do
          Rails.application.config.to_prepare do
            ::Decidim::Admin::ApplicationController.helper ::Decidim::LayoutHelper
          end
        end

        initializer "decidim_process_extended.webpacker.assets_path" do
          Decidim.register_assets_path File.expand_path("app/packs", root)
        end

        initializer "decidim_process_extended.content_blocks" do
          Decidim.content_blocks.register(:participatory_process_homepage, :social_networks_metadata) do |content_block|
            content_block.cell = "decidim/content_blocks/participatory_space_social_networks"
            content_block.public_name_key = "decidim.content_blocks.social_networks_metadata.name"
          end
        end

        # The social networks content block asks for "#{handler}-line" icons, but Decidim
        # does not register some of them, so they are rendered as the "other" icon (or
        # raise in development and test). Map them to the registered social icons.
        initializer "decidim_process_extended.icons" do
          Decidim.icons.register(name: "twitter-line", icon: "twitter-x-line", category: "social icon", description: "", engine: :core)
          Decidim.icons.register(name: "facebook-line", icon: "facebook-circle-line", category: "social icon", description: "", engine: :core)
          Decidim.icons.register(name: "github-line", icon: "github-fill", category: "social icon", description: "", engine: :core)
        end

        initializer "decidim_process_extended.notification_settings" do
          Decidim.notification_settings(:participatory_space_news) do |notification_setting|
            notification_setting.settings_area = :administrators
            notification_setting.default_value = false
          end
        end
      end
    end
  end
end
