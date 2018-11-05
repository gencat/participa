Rails.application.routes.draw do
  mount Decidim::Proposals::Best::Comments::Engine => "/decidim-proposals-best-comments"
end
