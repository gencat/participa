Rails.application.routes.draw do
  mount Decidim::Department::Engine => "/decidim-department"
end
