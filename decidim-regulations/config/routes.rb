# frozen_string_literal: true

Decidim::Regulations::Engine.routes.draw do
  get "regulations/:process_id", to: redirect { |params, _request|
                                       process = Decidim::ParticipatoryProcess.find_by(id: params[:process_id])
                                       process ? "/regulations/#{process.slug}" : "/regulations/"
                                     }, constraints: { process_id: /[0-9]+/ }
end
