# frozen_string_literal: true

module Decidim::Proposals::Import::ProposalCreatorDecorator
  def self.decorate
    Decidim::Proposals::Import::ProposalCreator.class_eval do
      def finish_without_notif!
        Decidim.traceability.perform_action!(:create, self.class.resource_klass, context[:current_user], visibility: "admin-only") do
          resource.save!
          resource
        end
        resource
      end
    end
  end
end

::Decidim::Proposals::Import::ProposalCreatorDecorator.decorate
