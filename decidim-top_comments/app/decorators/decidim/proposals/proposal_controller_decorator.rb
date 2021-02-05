# frozen_string_literal: true

Decidim::Proposals::ProposalsController.class_eval do
  include ::Decidim::Proposals::PositiveNegativeComments
end
