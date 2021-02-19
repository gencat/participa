# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Regulations::Engine => "/decidim-regulations"
end
