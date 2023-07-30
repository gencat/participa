# frozen_string_literal: true

module Decidim
  class AnswerConfirmationDeliveryJob < ApplicationJob
    queue_as :default

    def perform(user, questionnaire, participatory_space)
      answers = Decidim::Forms::QuestionnaireUserAnswers.for(questionnaire)
      
      SurveyConfirmationMailer.confirmation(user, questionnaire, answers, participatory_space).deliver_now
    end
  end
end
