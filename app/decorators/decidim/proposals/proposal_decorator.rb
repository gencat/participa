# frozen_string_literal: true

module Decidim::Proposals::ProposalDecorator
  def self.decorate
    Decidim::Proposals::Proposal.class_eval do
      scope :sort_by_attachments_count_asc, lambda {
        order(Arel.sql(
                "(SELECT COUNT(*) FROM decidim_attachments " \
                "WHERE decidim_attachments.attached_to_type = 'Decidim::Proposals::Proposal' " \
                "AND decidim_attachments.attached_to_id = decidim_proposals_proposals.id) ASC"
              ))
      }

      scope :sort_by_attachments_count_desc, lambda {
        order(Arel.sql(
                "(SELECT COUNT(*) FROM decidim_attachments " \
                "WHERE decidim_attachments.attached_to_type = 'Decidim::Proposals::Proposal' " \
                "AND decidim_attachments.attached_to_id = decidim_proposals_proposals.id) DESC"
              ))
      }
    end
  end
end

Decidim::Proposals::ProposalDecorator.decorate
