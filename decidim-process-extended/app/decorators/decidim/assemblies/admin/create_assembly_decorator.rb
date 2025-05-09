# frozen_string_literal: true

module Decidim::Assemblies::Admin::CreateAssemblyDecorator
  def call
    return broadcast(:invalid) if form.invalid?

    if assembly.persisted?
      add_admins_as_followers(assembly)
      link_participatory_processes(assembly)
      Decidim::ContentBlocksCreator.new(assembly).create_default!
      # process-extended customization
      Decidim::User.org_admins_except_me(current_user).find_each do |user|
        # Otherwise, it will be sent if realtime notifications are enabled
        notify_admin(user) if send_participatory_space_news_email?(user)
      end
      # process-extended customization

      broadcast(:ok, assembly)
    else
      form.errors.add(:hero_image, assembly.errors[:hero_image]) if assembly.errors.include? :hero_image
      form.errors.add(:banner_image, assembly.errors[:banner_image]) if assembly.errors.include? :banner_image
      broadcast(:invalid)
    end
  end

  private

  def notify_admin(user)
    data = {
      event: "decidim.events.participatory_space.created",
      event_class: Decidim::SimpleParticipatorySpaceEvent,
      resource: assembly,
      affected_users: [user],
      extra: {
        author_name: form.current_user.name,
        area: assembly.area&.name,
        start_date: assembly.creation_date,
        end_date: assembly.closing_date,
        force_email: send_participatory_space_news_email?(user)
      }
    }

    Decidim::EventsManager.publish(**data)
  end

  def send_participatory_space_news_email?(user)
    user.notification_settings.has_key?("participatory_space_news") && user.notification_settings["participatory_space_news"] == "1"
  end
end

Decidim::Assemblies::Admin::CreateAssembly.prepend(Decidim::Assemblies::Admin::CreateAssemblyDecorator)
