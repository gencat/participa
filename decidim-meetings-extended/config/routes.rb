Decidim::Meetings::Extended::Engine.routes.draw do

  get "/meetings-directory", to: "meetings_extended#meetings", as: :meetings_static

end
