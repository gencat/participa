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

      def produce
        if data[:meeting_url].present?
          resource.add_location(data[:meeting_url])
        elsif data.dig(:external_author, "name").present? || data[:"external_author/name"].present?
          resource.add_external_author(data.dig(:external_author, "name") || data[:"external_author/name"],
                                       context[:current_organization])
        else
          # Same as Decidim 0.31: imported proposals are authored by the organization
          resource.add_coauthor(component.organization)
        end

        resource
      end
    end
  end
end

Decidim::Proposals::Import::ProposalCreatorDecorator.decorate
