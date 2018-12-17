# frozen_string_literal: true

module Decidim
  module Admin
    # Custom ApplicationJob scoped to the admin panel.
    #
    class NewsletterJob < ApplicationJob
      queue_as :newsletter

      def perform(newsletter, id)
        @newsletter = newsletter
        @newsletter.with_lock do
          raise "Newsletter already sent" if @newsletter.sent?

          @newsletter.update_attributes!(
            sent_at: Time.current,
            total_recipients: recipients(id).count,
            total_deliveries: 0
          )
        end

        recipients(id).find_each do |user|
          NewsletterDeliveryJob.perform_later(user, @newsletter)
        end
      end

      private

      def recipients(id)
        users = User.where(organization: @newsletter.organization)
                            .where.not(newsletter_notifications_at: nil, email: nil, confirmed_at: nil)
                            .not_deleted
        if id.nil?
          @recipients ||= users
        else
          @recipients ||= users.joins("left outer join decidim_follows fol
                    on decidim_users.id = fol.decidim_user_id
                    left outer join decidim_proposals_proposals pro
                    on pro.id = fol.decidim_followable_id
                    left outer join decidim_components fea
                    on pro.decidim_component_id = fea.id
                    left outer join decidim_participatory_processes p
                    on p.id = fea.participatory_space_id
                    where fol.decidim_followable_type = 'Decidim::Proposals::Proposal' and p.id = " + id).distinct
        end
      end
    end
  end
end
