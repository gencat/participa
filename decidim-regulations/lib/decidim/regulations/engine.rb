require "rails"
require "active_support/all"

require "decidim/core"

module Decidim
  module Regulations
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Regulations
      # isolate_namespace Decidim::ParticipatoryProcesses

      routes do
          resources :participatory_process_groups, only: :show, path: "regulations_groups"
          resources :regulation, only: [:index, :show], path: "regulations" do
          resources :participatory_process_steps, only: [:index], path: "steps"
          resource :participatory_process_widget, only: :show, path: "embed"

          # resources :participatory_process, :path => "regulations", :controller => :participatory_processes
        end

        # FIXME: does not work
        scope "/regulations/:regulation_id/f/:feature_id" do
          Decidim.feature_manifests.each do |manifest|
            next unless manifest.engine

            constraints CurrentFeature.new(manifest) do
              mount manifest.engine, at: "/", as: "decidim_#{manifest.name}"
            end
          end
        end
      end

      initializer "decidim_regulations.append_routes", before: :load_config_initializers do |app|
        Rails.application.routes.append do
          mount Decidim::Regulations::Engine => "/"
        end
      end
    end
  end
end
