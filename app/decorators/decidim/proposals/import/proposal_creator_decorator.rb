# frozen_string_literal: true

Decidim::Proposals::Import::ProposalCreator.class_eval do
  def finish_without_notif!
    Decidim.traceability.perform_action!(:create, self.class.resource_klass, context[:current_user], visibility: "admin-only") do
      resource.save!
      resource
    end
    publish(resource)
    resource
  end
end
