# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.class_eval do
      fetch_form_attributes :organization, :title, :subtitle, :weight, :slug, :hashtag, :description,
                            :short_description, :promoted, :scopes_enabled, :scope, :announcement,
                            :scope_type_max_depth, :private_space, :developer_group, :local_area, :area, :target,
                            :participatory_scope, :participatory_structure, :meta_scope, :start_date, :end_date,
                            :participatory_process_group, :participatory_process_type,
                            :cost, :has_summary_record, :promoting_unit, :facilitators, :email

      def run_after_hooks
        create_steps

        # process-extended customization
        Decidim::User.org_admins_except_me(form.current_user).find_each do |user|
          # Otherwise, it will be sent if realtime notifications are enabled
          notify_admin(user) if send_participatory_space_news_email?(user)
        end
        # process-extended customization

        add_admins_as_followers
        link_related_processes
        Decidim::ContentBlocksCreator.new(resource).create_default!
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
  end
end

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator.decorate
