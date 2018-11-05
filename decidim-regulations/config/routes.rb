Decidim::Regulations::Engine.routes.draw do

    # get "/regulations", to: "regulation#index", as: :regulations_static

    # get "/regulations/:id", to: "/decidim/participatory_processes/participatory_processes#show", as: :regulation_static_view

    # get "/regulations/:participatory_process_id/steps", to: "decidim/participatory_process_steps#index"

    get "regulations/:process_id", to: redirect { |params, _request|
        process = Decidim::ParticipatoryProcess.where(id: params[:process_id]).first
            process ? "/regulations/#{process.slug}" : "/regulations/"        
      }, constraints: { process_id: /[0-9]+/ }

    # get "/processes/:process_id/f/:feature_id", to: redirect { |params, _request|
    #     process = Decidim::ParticipatoryProcess.where(id: params[:process_id]).first
    #     process ? "/regulations/#{process.slug}/f/#{params[:feature_id]}" : "/404"
    # }, constraints: { process_id: /[0-9]+/ }
    
end
