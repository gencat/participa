# frozen_string_literal: true

module Decidim
  class ParticipatoryProcessCreatedEvent < Decidim::Events::SimpleEvent
    include Decidim::Events::NotificationEvent

    def notification_title
      I18n.t("notification_title", **i18n_options).html_safe
    end

    def i18n_options
      {
        resource_path:,
        resource_title:,
        resource_url:,
        scope: event_name,
        participatory_space_title:,
        participatory_space_url:,
        author_name: extra[:author_name]
      }
    end
  end
end
