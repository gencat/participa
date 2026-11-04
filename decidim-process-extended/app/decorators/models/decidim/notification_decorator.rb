# frozen_string_literal: true

# Notifications about newly created participatory spaces are sent to admins
# while the space is still unpublished, so +can_participate?+ would hide them
# in the notifications page and in the notifications digest. Skip it for
# notifications flagged with +skip_can_participate+.
module Models::Decidim::NotificationDecorator
  def self.decorate
    Decidim::Notification.class_eval do
      def can_participate?(user)
        return true if extra&.with_indifferent_access&.dig(:skip_can_participate)

        resource.can_participate?(user)
      end
    end
  end
end

Models::Decidim::NotificationDecorator.decorate
