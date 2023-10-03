# frozen_string_literal: true

Decidim::Type::Engine.routes.draw do
  get "/admin/types", to: "/decidim/admin/types#index"
  get "/admin/types/new", to: "/decidim/admin/types#new"
  get "/admin/types/:id/edit", to: "/decidim/admin/types#edit"

  put "/admin/types/:id/edit", to: "/decidim/admin/types#update"
  put "/admin/types/new", to: "/decidim/admin/types#create"

  delete "/admin/types/:id", to: "/decidim/admin/types#destroy"

  get "/assembleaclima/inscripcions", to: "/decidim/participatory_processes#show"
end
