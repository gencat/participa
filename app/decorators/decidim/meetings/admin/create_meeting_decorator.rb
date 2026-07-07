# frozen_string_literal: true

# Adds google_maps_url to the attributes persisted when creating a meeting.
# Overrides Decidim::Meetings::Admin::CreateMeeting.
# Original: decidim_fork/decidim-meetings/app/commands/decidim/meetings/admin/create_meeting.rb
module Decidim::Meetings::Admin::CreateMeetingDecorator
  def self.decorate
    Decidim::Meetings::Admin::CreateMeeting.class_eval do
      alias_method :original_attributes, :attributes

      def attributes
        original_attributes.merge(google_maps_url: form.google_maps_url)
      end
    end
  end
end

Decidim::Meetings::Admin::CreateMeetingDecorator.decorate
