# frozen_string_literal: true

require "decidim/participatory_processes/content_blocks/highlighted_processes_cell"

module Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCellDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCell.class_eval do
      private

      def highlighted_processes
        @highlighted_processes ||= if max_results.to_i.zero?
                                     []
                                   else
                                     query = (
                                          ::Decidim::ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user) |
                                          ::Decidim::ParticipatoryProcesses::HighlightedParticipatoryProcesses.new |
                                          ::Decidim::ParticipatoryProcesses::FilteredParticipatoryProcesses.new("active")
                                        ).query.with_attached_hero_image.includes([:organization, :hero_image_attachment]).limit(highlighted_processes_max_results)

                                     # the only change from the original is the conditional to ignore regulations
                                     query
                                       .where
                                       .not(decidim_participatory_process_group_id: Rails.application.config.regulation)
                                       .or(query.where(decidim_participatory_process_group_id: nil))
                                       .includes([:organization])
                                       .limit(max_results)
                                   end
      end
    end
  end
end

::Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCellDecorator.decorate
