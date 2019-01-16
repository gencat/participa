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

      initializer "decidim_regulations.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Regulations::Engine.root}/app/cells")
      end

      initializer "decidim_regulations.content_blocks" do
        Decidim.content_blocks.register(:homepage, :highlighted_regulations) do |content_block|
          content_block.cell = "decidim/regulations/content_blocks/highlighted_regulations"
          content_block.public_name_key = "decidim.regulations.content_blocks.highlighted_regulations.name"
        end
      end
    end
  end
end
