# frozen_string_literal: true

module Decidim::Admin::ParticipatorySpace::PublishDecorator
  def self.decorate
    Decidim::Admin::ParticipatorySpace::Publish.class_eval do
      alias_method :original_call, :call unless method_defined?(:original_call)

      def call
        on(:ok) { notify_admins }

        original_call
      end

      private

      def notify_admins
        data = {
          event: "decidim.events.participatory_space.published",
          event_class: Decidim::SimpleParticipatorySpaceEvent,
          resource: participatory_space,
          affected_users: Decidim::User.org_admins_except_me(current_user),
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
