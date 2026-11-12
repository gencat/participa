# frozen_string_literal: true

# Adds the participatory process name to the meeting card metadata, but only when the
# meeting is shown outside its own participatory space (e.g. in the global meetings list).
module Decidim::Meetings::MeetingCardMetadataCellDecorator
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

unless Decidim::Meetings::MeetingCardMetadataCell.ancestors.include?(Decidim::Meetings::MeetingCardMetadataCellDecorator)
  Decidim::Meetings::MeetingCardMetadataCell.prepend(Decidim::Meetings::MeetingCardMetadataCellDecorator)
end
