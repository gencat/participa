# frozen_string_literal: true

# Adds the google_maps_url attribute and URL validation to the admin meeting form.
# Overrides Decidim::Meetings::Admin::MeetingForm.
# Original: decidim_fork/decidim-meetings/app/forms/decidim/meetings/admin/meeting_form.rb
module Decidim::Meetings::Admin::MeetingFormDecorator
  def self.decorate
    Decidim::Meetings::Admin::MeetingForm.class_eval do
      attribute :google_maps_url, String

      validates :google_maps_url, url: true, allow_blank: true,
                                  if: ->(form) { form.in_person_meeting? || form.hybrid_meeting? }
    end
  end
end

Decidim::Meetings::Admin::MeetingFormDecorator.decorate
