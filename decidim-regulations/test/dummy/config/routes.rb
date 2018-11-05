Rails.application.routes.draw do
  mount Decidim::Regulations::Engine => "/decidim-regulations"
end
