# frozen_string_literal: true

class DecidimsFinderController < Decidim::ApplicationController
  layout "layouts/decidim/application"

  helper_method :current_translations

  def show
    @current_translations = I18n.t("participagencat.decidims_finder_page")
  end
end
