# frozen_string_literal: true

module Decidim::Admin::ParticipatorySpace::PublishDecorator
  def self.decorate
    Decidim::Admin::ParticipatorySpace::Publish.class_eval do
      alias_method :original_call, :call

      def call
        subscribe(self) # from whisper gem

        result = original_call

        on(:ok) { notify_admins }
      end

      private

      def notify_admins
        data = {
          event: "decidim.events.participatory_space.published",
          event_class: Decidim::SimpleParticipatorySpaceEvent,
          resource: participatory_space,
          affected_users: Decidim::User.org_admins_except_me(form.current_user),
          extra: {
            author_name: current_user.name
          }
        }

        Decidim::EventsManager.publish(**data)
      end
    end
  end
end

Decidim::Admin::ParticipatorySpace::PublishDecorator.decorate
