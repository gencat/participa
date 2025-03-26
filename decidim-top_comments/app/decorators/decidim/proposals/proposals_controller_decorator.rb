# frozen_string_literal: true

module Decidim::Proposals::ProposalsControllerDecorator
  def self.decorate
    Decidim::Proposals::ProposalsController.class_eval do
      include ::Decidim::TopComments::PositiveNegativeComments
    end
  end
end

Decidim::Proposals::ProposalsControllerDecorator.decorate
