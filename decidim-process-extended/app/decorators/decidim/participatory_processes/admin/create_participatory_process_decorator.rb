# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
  def call
    return broadcast(:invalid) if form.invalid?

    create_participatory_process

    if process.persisted?
      # process-extended customization
      Decidim::User.org_admins_except_me(form.current_user).find_each do |user|
        # Otherwise, it will be sent if realtime notifications are enabled
        notify_admin(user) if send_participatory_space_news_email?(user)
      end
      # process-extended customization
      add_admins_as_followers(process)
      link_related_processes
      Decidim::ContentBlocksCreator.new(process).create_default!

      broadcast(:ok, process)
    else
      form.errors.add(:hero_image, process.errors[:hero_image]) if process.errors.include? :hero_image
      broadcast(:invalid)
    end
  end

  private

  def attributes
    super.merge({
                  cost: form.cost,
                  has_summary_record: form.has_summary_record,
                  promoting_unit: form.promoting_unit,
                  facilitators: form.facilitators,
                  email: form.email
                })
  end

  def notify_admin(user)
    data = {
      event: "decidim.events.participatory_space.created",
      event_class: Decidim::SimpleParticipatorySpaceEvent,
      resource: process,
      affected_users: [user],
      extra: {
        author_name: form.current_user.name,
        area: process.area&.name,
        start_date: process.start_date,
        end_date: process.end_date,
        force_email: send_participatory_space_news_email?(user)
      }
    }

    Decidim::EventsManager.publish(**data)
  end

  def send_participatory_space_news_email?(user)
    user.notification_settings.has_key?("participatory_space_news") && user.notification_settings["participatory_space_news"] == "1"
  end
end

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.prepend(Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator)
