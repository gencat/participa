Rails.application.routes.draw do
  mount Decidim::Search::User::Engine => "/decidim-search-user"
end
