Rails.application.routes.draw do
  mount Decidim::Home::Engine => "/decidim-home"
end
