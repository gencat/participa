# frozen_string_literal: true

Decidim.menu :menu do |menu|
  menu.item I18n.t("menu.regulations_static"),
            "/regulations",
            position: 2.75,
            active: :inclusive
end
