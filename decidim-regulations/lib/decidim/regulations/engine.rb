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
          resources :regulation, only: [:index], path: "regulations" do
          resources :participatory_process_steps, only: [:index], path: "steps"
          resource :participatory_process_widget, only: :show, path: "embed"

          # resources :participatory_process, :path => "regulations", :controller => :participatory_processes
        end

        # FIXME: does not work
        scope "/regulations/:regulation_id/f/:component_id" do
          Decidim.component_manifests.each do |manifest|
            next unless manifest.engine

            constraints CurrentComponent.new(manifest) do
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

      initializer "decidim_participatory_processes.view_hooks" do
        Decidim.view_hooks.register(:highlighted_elements, priority: Decidim::ViewHooks::MEDIUM_PRIORITY) do |view_context|
          highlighted_regulations = Decidim::ParticipatoryProcess.where(organization: view_context.current_organization, decidim_participatory_process_group_id: Rails.application.config.regulation).where('DATE(published_at) > \'1990/01/01\'' ).order(published_at: :desc).limit(8)

          next unless highlighted_regulations.any?

          view_context.render(
            partial: "decidim/regulations/pages/home/highlighted_regulations",
            locals: {
              highlighted_regulations: highlighted_regulations
            }
          )
        end
      end
    end
  end
end
