# frozen_string_literal: true

module Decidim::Debates::DebatesControllerDecorator
  def self.decorate
    Decidim::Debates::DebatesController.class_eval do
      include ::Decidim::TopComments::PositiveNegativeComments
    end
  end
end

::Decidim::Debates::DebatesControllerDecorator.decorate
