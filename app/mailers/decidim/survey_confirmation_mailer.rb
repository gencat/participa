# frozen_string_literal: true

module Decidim
  class SurveyConfirmationMailer < ApplicationMailer
    include TranslatableAttributes
    helper Decidim::SanitizeHelper

    def confirmation(user, questionnaire, answers, participatory_space)
      @user = user
      @questionnaire = questionnaire
      @participatory_space = participatory_space
      @organization = user.organization

      return unless answers.present?

      export_name = t("decidim.surveys.surveys.confirmation_email.export_name")
      serializer = Decidim::Forms::UserAnswersSerializer

      export_data = Decidim::Exporters::FormPDF.new(answers, serializer).export
      
      filename = export_data.filename(export_name)
      filename_without_extension = export_data.filename(export_name, extension: false)

      attachments["#{filename_without_extension}.zip"] = FileZipper.new(filename, export_data.read).zip

      mail(to: "#{@user.name} <#{@user.email}>", subject: t("decidim.surveys.surveys.confirmation_email.subject"))
    end
  end
end
