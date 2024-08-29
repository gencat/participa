# frozen_string_literal: true

Decidim.menu :home_content_block_menu do |menu|
  menu.add_item :regulations,
                I18n.t("menu.regulations_static"),
                "/regulations",
                position: 12,
                active: :inclusive
end
