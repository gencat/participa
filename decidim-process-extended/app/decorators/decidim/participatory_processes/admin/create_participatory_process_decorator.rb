# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
  def call
    return broadcast(:invalid) if form.invalid?

    create_participatory_process

    if process.persisted?
      # process-extended customization
      notify_admins
      # process-extended customization
      add_admins_as_followers(process)
      link_related_processes
      Decidim::ContentBlocksCreator.new(process).create_default!

      broadcast(:ok, process)
    else
      form.errors.add(:hero_image, process.errors[:hero_image]) if process.errors.include? :hero_image
      form.errors.add(:banner_image, process.errors[:banner_image]) if process.errors.include? :banner_image
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

  def notify_admins
    data = {
      event: "decidim.events.participatory_space.created",
      event_class: Decidim::SimpleParticipatorySpaceEvent,
      resource: process,
      affected_users: Decidim::User.org_admins_except_me(form.current_user)
      extra: {
        author_name: current_user.name,
        area: translated_attribute(process.area&.name),
        start_date: process.start_date,
        end_date: process.end_date
      }
    }

    Decidim::EventsManager.publish(**data)
  end
end

::Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.prepend(Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator)
