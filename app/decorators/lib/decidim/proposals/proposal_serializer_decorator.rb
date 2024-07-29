# frozen_string_literal: true

module Decidim::Proposals::ProposalSerializerDecorator
  def self.decorate
    Decidim::Proposals::ProposalSerializer.class_eval do
      alias_method :original_serialize, :serialize

      # Add authors to proposal exportation
      def serialize
        original_serialize.merge({
                                   authors_names: proposal.authors.pluck(:name)
                                 })
      end
    end
  end
end

::Decidim::Proposals::ProposalSerializerDecorator.decorate
