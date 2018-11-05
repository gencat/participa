Decidim.menu :menu do |menu|  

    menu.item I18n.t("menu.meetings_static"),
              "/meetings",
              position: 3,
              active: :inclusive

end
