# frozen_string_literal: true

Decidim::Proposals::ProposalsController.class_eval do
  include ::Decidim::TopComments::PositiveNegativeComments
end
