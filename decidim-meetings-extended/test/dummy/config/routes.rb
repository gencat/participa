Rails.application.routes.draw do
  mount Decidim::Meetings::Extended::Engine => "/decidim-meetings-extended"
end
