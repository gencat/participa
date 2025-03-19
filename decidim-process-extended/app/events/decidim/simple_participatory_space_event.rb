# frozen_string_literal: true

module Decidim
  class SimpleParticipatorySpaceEvent < Decidim::Events::SimpleEvent
    include Decidim::Events::EmailEvent
    include Decidim::Events::NotificationEvent

    def notification_title
      I18n.t("notification_title", **i18n_options).html_safe
    end

    # To remove the link to the resource in the notification email
    def resource_path
      nil
    end

    def i18n_options
      {
        resource_title:,
        resource_url:,
        scope: event_name,
        resource_type:,
        author_name: extra[:author_name],
        start_date: process?(resource) ? resource&.start_date : nil,
        end_date: process?(resource) ? resource&.end_date : nil,
        area: translated_attribute(resource&.area&.name)
      }
    end

    def resource_type
      if process?(resource)
        if resource.regulation?
          I18n.t("regulation", scope: event_name)
        else
          I18n.t("process", scope: event_name)
        end
      else
        I18n.t("assembly", scope: event_name)
      end
    end

    def process?(resource)
      resource.is_a?(Decidim::ParticipatoryProcess)
    end
  end
end
