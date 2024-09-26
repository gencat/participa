# frozen_string_literal: true

class ProposalsAnswersMailer < ApplicationMailer
  include Decidim::SanitizeHelper
  include Decidim::ComponentPathHelper

  layout "decidim/mailer"

  def notify_massive_import(answers_collection, user)
    @organization = user.organization
    first_answer = answers_collection.first
    @participatory_space_title = decidim_sanitize_translated(first_answer.participatory_space.title) if first_answer.present?
    @user = user
    @component_url = manage_component_url(first_answer.component)
    I18n.locale = user.locale if user.locale.present?

    subject = I18n.t("proposals_answers_imported.email_subject", scope: "decidim.events.proposals", participatory_space_title: @participatory_space_title)
    mail(to: user.email, subject: subject)
  end

  private

  def manage_component_url(component)
    Decidim::EngineRouter.main_proxy(component).root_url
  end
end
