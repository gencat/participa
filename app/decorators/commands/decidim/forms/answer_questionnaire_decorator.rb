# frozen_string_literal: true

Decidim::Forms::AnswerQuestionnaire.class_eval do
  alias_method :original_call, :call
  
  def call
    return broadcast(:invalid) if @form.invalid? || user_already_answered?
    
    if current_component.settings.send_confirmation_email
      answer_questionnaire

      Decidim::AnswerConfirmationDeliveryJob.perform_now(@current_user, questionnaire, current_component.participatory_space)

      if @errors
        reset_form_attachments
        broadcast(:invalid)
      else
        broadcast(:ok)
      end
    else
      original_call
    end
  end
end
