# frozen_string_literal: true

class ProposalsAnswersMailer < ApplicationMailer
  include Decidim::SanitizeHelper
  include Decidim::ComponentPathHelper

  layout "decidim/mailer"

  def notify_massive_import(answers_collection, user)
    @organization = user.organization
    @participatory_space_title = decidim_sanitize_translated(answers_collection.first.participatory_space.title) if answers_collection.first.present?
    @user = user
    @component_url = manage_component_url(answers_collection.first.component)
    I18n.locale = user.locale if user.locale.present?

    subject = I18n.t("proposals_answers_publisheds_for_space.email_subject", scope: "decidim.events.proposals", participatory_space_title: @participatory_space_title)
    mail(to: user, subject: subject)
  end

  private

  def manage_component_url(component)
    Decidim::EngineRouter.main_proxy(component).root_url
  end
end
