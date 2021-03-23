# frozen_string_literal: true

Decidim::Debates::DebatesController.class_eval do
  include ::Decidim::TopComments::PositiveNegativeComments
end
