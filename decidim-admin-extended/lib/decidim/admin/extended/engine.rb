# frozen_string_literal: true

require "rails"
require "active_support/all"
require "decidim/core"
require "decidim/admin"

module Decidim
  module Admin
    # Decidim's core Rails Engine.
    module Extended
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::Admin::Extended

        paths["db/migrate"] = nil

        routes do
          resource :more_configuration, only: :show
        end

        initializer "decidim_admin_extended.append_routes", before: :load_config_initializers do |app|
          Rails.application.routes.append do
            mount Decidim::Admin::Extended::Engine => "/"
          end
        end

        initializer "decidim_admin_extended.assets" do |app|
          app.config.assets.precompile += %w(decidim_admin_extended_manifest.js)
        end

        initializer "decidim_admin_extended.menu" do
          Decidim.menu :admin_menu do |menu|
            menu.item I18n.t("menu.custom_configuration", scope: "decidim.admin.extended"),
                      "/admin/types",
                      icon_name: "wrench",
                      position: 9,
                      active: [%w(decidim/admin/themes decidim/admin/types decidim/admin/departments), []]
          end
        end
      end
    end
  end
end
