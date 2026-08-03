# frozen_string_literal: true

module Decidim::Forms::QuestionnaireDecorator
  def self.decorate
    Decidim::Forms::Questionnaire.class_eval do
      def organization
        questionnaire_for&.organization
      end
    end
  end
end

Decidim::Forms::QuestionnaireDecorator.decorate
