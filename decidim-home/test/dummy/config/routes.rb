# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Home::Engine => "/decidim-home"
end
