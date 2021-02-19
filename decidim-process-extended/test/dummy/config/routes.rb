# frozen_string_literal: true

Rails.application.routes.draw do
  mount Decidim::Process::Extended::Engine => "/decidim-process-extended"
end
