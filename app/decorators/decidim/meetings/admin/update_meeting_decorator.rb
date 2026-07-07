# frozen_string_literal: true

# Adds google_maps_url to the attributes persisted when updating a meeting.
# Overrides Decidim::Meetings::Admin::UpdateMeeting.
# Original: decidim_fork/decidim-meetings/app/commands/decidim/meetings/admin/update_meeting.rb
module Decidim::Meetings::Admin::UpdateMeetingDecorator
  def self.decorate
    Decidim::Meetings::Admin::UpdateMeeting.class_eval do
      alias_method :original_attributes, :attributes

      def attributes
        original_attributes.merge(google_maps_url: form.google_maps_url)
      end
    end
  end
end

Decidim::Meetings::Admin::UpdateMeetingDecorator.decorate
