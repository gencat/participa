# frozen_string_literal: true

class ProposalsMailer < ApplicationMailer
  include Decidim::SanitizeHelper
  include Decidim::ComponentPathHelper

  layout "decidim/mailer"

  def notify_massive_import(proposals_collection, user)
    @organization = user.organization
    @participatory_space_title = decidim_sanitize_translated(proposals_collection.first.participatory_space.title) if proposals_collection.first.present?
    @user = user
    @component_url = manage_component_url(proposals_collection.first.component)
    I18n.locale = user.locale if user.locale.present?

    subject = I18n.t("proposals_publisheds_for_space.email_subject", scope: "decidim.events.proposals", participatory_space_title: @participatory_space_title)
    mail(to: user.email, subject: subject)
  end

  private

  def manage_component_url(component)
    Decidim::EngineRouter.main_proxy(component).root_url
  end
end
