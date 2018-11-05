Rails.application.routes.draw do
  mount Decidim::Theme::Engine => "/decidim-theme"
end
