# frozen_string_literal: true
Rails.application.config.to_prepare do
  Decidim.menu :menu do |menu|
    menu.add_item :regulations,
                  I18n.t("menu.regulations_static"),
                  "/regulations",
                  position: 2.1,
                  active: :inclusive
  end

  Decidim.menu :home_content_block_menu do |menu|
    menu.add_item :regulations,
                  I18n.t("menu.regulations_static"),
                  "/regulations",
                  position: 30,
                  active: :inclusive
  end
end
