# frozen_string_literal: true

module Decidim
  module Regulations
    module ContentBlocks
      class HighlightedRegulationsCell < Decidim::ContentBlocks::HighlightedParticipatorySpacesCell
        # ## Ordering Regulations in the **Highlighted Regulations** content block:
        # Criteria for ordering which processes are displayed and in what order in the "Highlighted Regulations" content block:
        #
        # 1. Participatory process that belongs to the organization
        # 2. Visible to the user (public/private)
        # 3. Processes belong to a group marked as "regulations"
        # 4. The publication date is later than 01/01/1990
        # 5. Ordered by publication date from most recent to oldest
        # 6. Finally, the limit of visible processes configured in the back office is taken into account
        #
        # Therefore, it does not take into account whether the process is promoted or not, whether it is active or completed, nor the phase dates.

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
            .limit(max_results)
        end
      end
    end
  end
end
