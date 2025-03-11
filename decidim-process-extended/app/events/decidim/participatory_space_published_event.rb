# frozen_string_literal: true

module Decidim
  class ParticipatorySpacePublishedEvent < Decidim::Events::SimpleEvent
    include Decidim::Events::EmailEvent
    include Decidim::Events::NotificationEvent

    def notification_title
      I18n.t("notification_title", **i18n_options).html_safe
    end

    def email_intro
      super.html_safe
    end

    def email_outro
    end

    def i18n_options
      {
        resource_path:,
        resource_title:,
        resource_url:,
        scope: event_name,
        participatory_space_title:,
        participatory_space_url:,
        user_name: extra[:user_name],
        resource_type:,
        start_date: resource.start_date,
        end_date: resource.end_date,
        area:,


      }
    end

    def resource_type
      if resource.is_a?(Decidim::ParticipatoryProcess)
        if resource.is_regulation?
          I18n.t("regulation", scope: event_name)
        else
          I18n.t("process", scope: event_name)
        end
      else
        I18n.t("assembly", scope: event_name)
      end
    end

    def area
      byebug
    end
  end
end
