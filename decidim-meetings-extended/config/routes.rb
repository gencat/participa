Decidim::Meetings::Extended::Engine.routes.draw do

  get "/meetings", to: "meetings_extended#meetings", as: :meetings_static

end
