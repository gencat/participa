# frozen_string_literal: true

module Decidim::Admin::ParticipatorySpace::PublishDecorator
  def self.decorate
    Decidim::Admin::ParticipatorySpace::Publish.class_eval do
      def call
        return broadcast(:invalid) if participatory_space.nil? || participatory_space.published?
    
        Decidim.traceability.perform_action!(:publish, participatory_space, user, **default_options) do
          participatory_space.publish!
          # process-extended customization
          notify_admins
          # process-extended customization
        end
    
        broadcast(:ok, participatory_space)
      end
    
      private
    
      def notify_admins
        data = {
          event: "decidim.events.participatory_space.published",
          event_class: Decidim::SimpleParticipatorySpaceEvent,
          resource: participatory_space,
          affected_users: Decidim::User.org_admins_except_me(form.current_user)
          extra: {
            author_name: current_user.name
          }
        }
    
        Decidim::EventsManager.publish(**data)
      end
    end
  end
end

::Decidim::Admin::ParticipatorySpace::PublishDecorator.decorate
