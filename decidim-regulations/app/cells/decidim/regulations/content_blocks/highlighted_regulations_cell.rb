# frozen_string_literal: true

module Decidim
  module Regulations
    module ContentBlocks
      class HighlightedRegulationsCell < Decidim::ViewModel
        include Decidim::SanitizeHelper

        delegate :current_organization, to: :controller
        delegate :current_user, to: :controller

        def show
          if single_regulation?
            render "single_regulation"
          elsif highlighted_regulations.any?
            render
          end
        end

        def single_regulation?
          highlighted_regulations.to_a.length == 1
        end

        def highlighted_regulations
          Decidim::ParticipatoryProcess
            .where(organization: current_organization, decidim_participatory_process_group_id: Rails.application.config.regulation)
            .visible_for(current_user)
            .where("DATE(published_at) > '1990/01/01'")
            .order(published_at: :desc)
            .limit(8)
        end

        def i18n_scope
          "decidim.regulations.pages.home.highlighted_regulations"
        end

        def decidim_participatory_processes
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        end
      end
    end
  end
end
