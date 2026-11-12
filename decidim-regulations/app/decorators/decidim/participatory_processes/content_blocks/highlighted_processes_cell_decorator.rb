# frozen_string_literal: true

# require "decidim/participatory_processes/content_blocks/highlighted_processes_cell"

module Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCellDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCell.class_eval do
      private

      # Same as the original, but ignoring the regulations. The limit leaves room for the promoted groups,
      # which are shown in the same block.
      def highlighted_processes
        @highlighted_processes ||= if highlighted_processes_max_results.zero?
                                     []
                                   else
                                     query = (
                                       ::Decidim::ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user) |
                                       ::Decidim::ParticipatoryProcesses::HighlightedParticipatoryProcesses.new |
                                       ::Decidim::ParticipatoryProcesses::FilteredParticipatoryProcesses.new("active")
                                     ).query

                                     query
                                       .where.not(decidim_participatory_process_group_id: Rails.application.config.regulation)
                                       .or(query.where(decidim_participatory_process_group_id: nil))
                                       .with_attached_hero_image
                                       .includes([:organization, :hero_image_attachment])
                                       .limit(highlighted_processes_max_results)
                                   end
      end
    end
  end
end

Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCellDecorator.decorate
