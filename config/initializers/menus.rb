# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim.menu :menu do |menu|
    menu.add_item :decidims_finder,
                  I18n.t("menu.decidims_finder", scope: "participagencat"),
                  Rails.application.routes.url_helpers.decidims_finder_page_path,
                  position: 2.2,
                  active: :inclusive
  end

  Decidim.menu :home_content_block_menu do |menu|
    menu.add_item :decidims_finder,
                  I18n.t("menu.decidims_finder", scope: "participagencat"),
                  Rails.application.routes.url_helpers.decidims_finder_page_path,
                  position: 50,
                  active: :inclusive
  end
end
