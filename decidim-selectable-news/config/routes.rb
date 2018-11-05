Decidim::Selectable::News::Engine.routes.draw do

    get "/admin/newsletter/:id/deliver_process/:process_id", to: "/decidim/admin/newsletters#deliver_custom_process"

end
