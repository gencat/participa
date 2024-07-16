# frozen_string_literal: true

module Decidim::Proposals::ProposalSerializerDecorator
  def self.decorate
    Decidim::Proposals::ProposalSerializer.class_eval do
      # Add authors to proposal exportation
      def serialize
        {
          id: proposal.id,
          category: {
            id: proposal.category.try(:id),
            name: proposal.category.try(:name) || empty_translatable
          },
          scope: {
            id: proposal.scope.try(:id),
            name: proposal.scope.try(:name) || empty_translatable
          },
          participatory_space: {
            id: proposal.participatory_space.id,
            url: Decidim::ResourceLocatorPresenter.new(proposal.participatory_space).url
          },
          component: { id: component.id },
          title: proposal.title,
          body: convert_to_plain_text(proposal.body),
          address: proposal.address,
          latitude: proposal.latitude,
          longitude: proposal.longitude,
          state: proposal.state.to_s,
          reference: proposal.reference,
          answer: ensure_translatable(proposal.answer),
          supports: proposal.proposal_votes_count,
          endorsements: {
            total_count: proposal.endorsements.size,
            user_endorsements: user_endorsements
          },
          comments: proposal.comments_count,
          attachments: proposal.attachments.size,
          followers: proposal.follows.size,
          published_at: proposal.published_at,
          url: url,
          meeting_urls: meetings,
          related_proposals: related_proposals,
          is_amend: proposal.emendation?,
          original_proposal: {
            title: proposal&.amendable&.title,
            url: original_proposal_url
          },
          # Gencat customization
          authors_names: proposal.authors.pluck(:name),
          authors_emails: proposal.authors.pluck(:email)
          # Gencat customization
        }
      end
    end
  end
end

::Decidim::Proposals::ProposalSerializerDecorator.decorate
