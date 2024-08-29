# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim.menu :home_content_block_menu do |menu|
    menu.add_item :decidims_finder,
              I18n.t("menu.decidims_finder", scope: "participagencat"),
              Rails.application.routes.url_helpers.decidims_finder_page_path,
              position: 14,
              active: :inclusive
  end
end
