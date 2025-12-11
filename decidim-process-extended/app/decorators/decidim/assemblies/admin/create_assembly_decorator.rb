# frozen_string_literal: true

module Decidim::Assemblies::Admin::CreateAssemblyDecorator
  def self.decorate
    Decidim::Assemblies::Admin::CreateAssembly.class_eval do
      def run_after_hooks
        add_admins_as_followers
        link_participatory_processes
        Decidim::ContentBlocksCreator.new(resource).create_default!
        # process-extended customization
        Decidim::User.org_admins_except_me(form.current_user).find_each do |user|
          # Otherwise, it will be sent if realtime notifications are enabled
          notify_admin(user) if send_participatory_space_news_email?(user)
        end
        # process-extended customization
      end

      private

      def notify_admin(user)
        data = {
          event: "decidim.events.participatory_space.created",
          event_class: Decidim::SimpleParticipatorySpaceEvent,
          resource:,
          affected_users: [user],
          extra: {
            author_name: form.current_user.name,
            area: resource.area&.name,
            start_date: resource.creation_date,
            end_date: resource.closing_date,
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

Decidim::Assemblies::Admin::CreateAssemblyDecorator.decorate
