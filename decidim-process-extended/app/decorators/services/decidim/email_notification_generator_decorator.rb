# frozen_string_literal: true

module Services::Decidim::EmailNotificationGeneratorDecorator
  def self.decorate
    Decidim::EmailNotificationGenerator.class_eval do
      def should_send_email?(recipient)
        # participa customization
        return true if is_from_participatory_space_news?(extra) && send_participatory_space_news_email?(recipient)
        # participa customization

        return extra[:force_email] if extra.has_key?(:force_email)

        recipient.notifications_sending_frequency == "real_time"
      end

      private

      def is_from_participatory_space_news?(extra)
        extra.has_key?(:participatory_space_news) && extra[:participatory_space_news]
      end

      def send_participatory_space_news_email?(recipient)
        recipient.notification_settings.has_key?("participatory_space_news") && recipient.notification_settings["participatory_space_news"] == "1"
      end
    end
  end
end

Services::Decidim::EmailNotificationGeneratorDecorator.decorate
