# frozen_string_literal: true

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
