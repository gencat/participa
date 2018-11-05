Decidim::Theme::Engine.routes.draw do

    get "/admin/themes", to: "/decidim/admin/themes#index"
    get "/admin/themes/new", to: "/decidim/admin/themes#new"
    get "/admin/themes/:id/edit", to: "/decidim/admin/themes#edit"

    put '/admin/themes/new', :to => '/decidim/admin/themes#create'
    put '/admin/themes/:id/edit', :to => '/decidim/admin/themes#update'

    delete "/admin/themes/:id", to: "/decidim/admin/themes#destroy"
end
