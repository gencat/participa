# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Type::Engine => "/decidim-type"
end
