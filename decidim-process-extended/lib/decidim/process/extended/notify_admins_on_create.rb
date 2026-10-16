# frozen_string_literal: true

module Decidim
  module Process
    module Extended
      # Notifies the organization admins when a participatory space is created.
      #
      # Prepended to the space creation commands (instead of redefining
      # `run_after_hooks` with class_eval) so that it composes with Decidim and with
      # other decorators of the command, like the ones in decidim-department_admin
      # that assign the department of the space.
      #
      # The including command must define `notification_dates`, returning the
      # `[start_date, end_date]` of the created space.
      module NotifyAdminsOnCreate
        protected

        def run_after_hooks
          super

          Decidim::User.org_admins_except_me(form.current_user).find_each do |user|
            # Otherwise, it will be sent if realtime notifications are enabled
            notify_admin(user) if send_participatory_space_news_email?(user)
          end
        end

        private

        def notify_admin(user)
          start_date, end_date = notification_dates

          Decidim::EventsManager.publish(
            event: "decidim.events.participatory_space.created",
            event_class: Decidim::SimpleParticipatorySpaceEvent,
            resource:,
            affected_users: [user],
            extra: {
              author_name: form.current_user.name,
              area: resource.area&.name,
              start_date:,
              end_date:,
              force_email: send_participatory_space_news_email?(user)
            }
          )
        end

        def send_participatory_space_news_email?(user)
          user.notification_settings.has_key?("participatory_space_news") && user.notification_settings["participatory_space_news"] == "1"
        end
      end
    end
  end
end
