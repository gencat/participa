Rails.application.routes.draw do
  mount Decidim::Selectable::News::Engine => "/decidim-selectable-news"
end
