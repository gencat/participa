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
          resource.add_external_author((data.dig(:external_author, "name") || data[:"external_author/name"]),
                                       context[:current_organization])
        else
          resource.add_coauthor(context[:current_user], user_group: context[:user_group])
        end

        resource
      end
    end
  end
end

Decidim::Proposals::Import::ProposalCreatorDecorator.decorate
