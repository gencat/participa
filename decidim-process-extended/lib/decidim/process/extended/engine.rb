# frozen_string_literal: true

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
