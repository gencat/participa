# frozen_string_literal: true

# For participatory space creation events we need to notify admins even when
# the newly created space is not yet participable/published.
#
# Decidim skips the email and the notification when the recipient cannot
# participate in the resource. For events flagged with +skip_can_participate+
# that check is skipped; any other event keeps Decidim's original behaviour.
module Services
  module Decidim
    module NotificationGeneratorsDecorator
      module SkipCanParticipateOnEmail
        private

        def send_email_to(recipient, user_role:)
          return super unless extra[:skip_can_participate]
          return unless recipient
          return unless should_send_email?(recipient)

          wait_time = 0
          wait_time = ::Decidim.machine_translation_delay.to_i + 1.minute if recipient.organization.enable_machine_translations

          ::Decidim::NotificationMailer
            .event_received(event, event_class.name, resource, recipient, user_role.to_s, extra)
            .deliver_later(wait: wait_time)
        end
      end

      module SkipCanParticipateOnNotification
        private

        def generate_notification_for(recipient, user_role:)
          return super unless extra[:skip_can_participate]

          ::Decidim::NotificationGeneratorForRecipientJob.perform_later(
            event, event_class.name, resource, recipient, user_role.to_s, extra
          )
        end
      end

      def self.decorate
        ::Decidim::EmailNotificationGenerator.prepend(SkipCanParticipateOnEmail) unless ::Decidim::EmailNotificationGenerator.ancestors.include?(SkipCanParticipateOnEmail)
        ::Decidim::NotificationGenerator.prepend(SkipCanParticipateOnNotification) unless ::Decidim::NotificationGenerator.ancestors.include?(SkipCanParticipateOnNotification)
      end
    end
  end
end

Services::Decidim::NotificationGeneratorsDecorator.decorate
