# frozen_string_literal: true

module Decidim
  module Regulations
    module ContentBlocks
      class HighlightedRegulationsCell < Decidim::ContentBlocks::HighlightedParticipatorySpacesCell
        delegate :current_user, to: :controller

        def highlighted_spaces
          @highlighted_spaces ||= highlighted_regulations
        end

        alias limited_highlighted_spaces highlighted_spaces

        def i18n_scope
          "decidim.regulations.pages.home.highlighted_regulations"
        end

        def all_path
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers.participatory_processes_path
        end

        def max_results
          model.settings.max_results
        end

        private

        def block_id
          "highlighted-regulations"
        end

        def highlighted_regulations
          Decidim::ParticipatoryProcess
            .where(organization: current_organization, decidim_participatory_process_group_id: Rails.application.config.regulation)
            .visible_for(current_user)
            .where("DATE(published_at) > '1990/01/01'")
            .order(published_at: :desc)
            .limit(8)
        end
      end
    end
  end
end
