# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim.menu :menu do |menu|
    menu.item I18n.t("menu.decidims_finder", scope: "participagencat"),
              Rails.application.routes.url_helpers.decidims_finder_page_path,
              position: 6,
              active: :inclusive
  end
end
