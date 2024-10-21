# frozen_string_literal: true

module Decidim::Proposals::Import::ProposalAnswerCreatorDecorator
  def self.decorate
    Decidim::Proposals::Import::ProposalAnswerCreator.class_eval do
      def finish_without_notif!
        Decidim.traceability.perform_action!(
          "answer",
          resource,
          current_user
        ) do
          resource.try(:save!)
        end
        resource
      end
    end
  end
end

Decidim::Proposals::Import::ProposalAnswerCreatorDecorator.decorate
