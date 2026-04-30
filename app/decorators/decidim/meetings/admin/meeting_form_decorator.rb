# frozen_string_literal: true

# Adds the google_maps_url attribute and URL validation to the admin meeting form.
# Only URLs from allowed Google Maps domains are accepted:
#   https://www.google.com/maps/
#   https://maps.app.goo.gl
# Overrides Decidim::Meetings::Admin::MeetingForm.
# Original: decidim_fork/decidim-meetings/app/forms/decidim/meetings/admin/meeting_form.rb
module Decidim::Meetings::Admin::MeetingFormDecorator
  def self.decorate
    Decidim::Meetings::Admin::MeetingForm.class_eval do
      attribute :google_maps_url, String

      validates :google_maps_url, url: true, allow_blank: true,
                                  if: ->(form) { form.in_person_meeting? || form.hybrid_meeting? }

      validate :google_maps_url_domain, if: -> { google_maps_url.present? && (in_person_meeting? || hybrid_meeting?) }

      def google_maps_url_domain
        return if google_maps_url.start_with?("https://www.google.com/maps/", "https://maps.app.goo.gl")

        errors.add(:google_maps_url, :invalid_google_maps_domain)
      end
    end
  end
end

Decidim::Meetings::Admin::MeetingFormDecorator.decorate
