# frozen_string_literal: true

module Decidim
  module Meetings
    module MeetingCardMetadataCellExtension
      extend ActiveSupport::Concern

      private

      def meeting_items
        items = super
        items << participatory_process_item if show_participatory_process?
        items
      end

      def participatory_process_item
        {
          text: translated_attribute(meeting.component.participatory_space.title),
          icon: "government-line"
        }
      end

      def show_participatory_process?
        current_participatory_space = try(:current_participatory_space)

        current_participatory_space.nil? ||
          current_participatory_space != meeting.component.participatory_space
      end
    end
  end
end

Decidim::Meetings::MeetingCardMetadataCell.prepend(
  Decidim::Meetings::MeetingCardMetadataCellExtension
)