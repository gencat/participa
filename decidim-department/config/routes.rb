Decidim::Department::Engine.routes.draw do
  get "/admin/departments", to: "/decidim/admin/departments#index"
  get "/admin/departments/new", to: "/decidim/admin/departments#new"
  get "/admin/departments/:id/edit", to: "/decidim/admin/departments#edit"

  put '/admin/departments/:id/edit', :to => '/decidim/admin/departments#update'
  put '/admin/departments/new', :to => '/decidim/admin/departments#create'

  delete "/admin/departments/:id", to: "/decidim/admin/departments#destroy"
end
