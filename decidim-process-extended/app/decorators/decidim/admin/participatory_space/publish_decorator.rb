# frozen_string_literal: true

module Decidim::Admin::ParticipatorySpace::PublishDecorator
  def self.decorate
    Decidim::Admin::ParticipatorySpace::Publish.class_eval do
      alias_method :original_call, :call unless method_defined?(:original_call)

      def call
        on(:ok) do
          Decidim::User.org_admins_except_me(current_user).find_each do |user|
            # Otherwise, it will be sent if realtime notifications are enabled
            notify_admin(user) if send_participatory_space_news_email?(user)
          end
        end

        original_call
      end

      private

      def notify_admin(user)
        data = {
          event: "decidim.events.participatory_space.published",
          event_class: Decidim::SimpleParticipatorySpaceEvent,
          resource: participatory_space,
          affected_users: [user],
          extra: {
            author_name: current_user.name,
            force_email: send_participatory_space_news_email?(user)
          }
        }

        Decidim::EventsManager.publish(**data)
      end

      def send_participatory_space_news_email?(user)
        user.notification_settings.has_key?("participatory_space_news") && user.notification_settings["participatory_space_news"] == "1"
      end
    end
  end
end

Decidim::Admin::ParticipatorySpace::PublishDecorator.decorate
