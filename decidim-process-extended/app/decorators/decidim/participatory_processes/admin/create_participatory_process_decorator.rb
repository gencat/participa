# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
  # Prepended (instead of redefining `run_after_hooks` with class_eval) so that it
  # composes with Decidim and with other decorators of the command, like the one in
  # decidim-department_admin that assigns the department of the process.
  module NotifyAdmins
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
      data = {
        event: "decidim.events.participatory_space.created",
        event_class: Decidim::SimpleParticipatorySpaceEvent,
        resource:,
        affected_users: [user],
        extra: {
          author_name: form.current_user.name,
          area: resource.area&.name,
          start_date: resource.start_date,
          end_date: resource.end_date,
          force_email: send_participatory_space_news_email?(user)
        }
      }

      Decidim::EventsManager.publish(**data)
    end

    def send_participatory_space_news_email?(user)
      user.notification_settings.has_key?("participatory_space_news") && user.notification_settings["participatory_space_news"] == "1"
    end
  end

  def self.decorate
    klass = Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess
    klass.class_eval do
      fetch_form_attributes :organization, :title, :subtitle, :weight, :slug, :hashtag, :description,
                            :short_description, :promoted, :taxonomizations, :announcement,
                            :private_space, :developer_group, :local_area, :target,
                            :participatory_scope, :participatory_structure, :meta_scope, :start_date, :end_date,
                            :participatory_process_group,
                            :cost, :has_summary_record, :promoting_unit, :facilitators, :email
    end
    klass.prepend(NotifyAdmins) unless klass.ancestors.include?(NotifyAdmins)
  end
end

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator.decorate
