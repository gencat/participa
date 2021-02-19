# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Espais::Estables::Engine => "/decidim-espais-estables"
end
