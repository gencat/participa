# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :top_comments_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :top_comments).i18n_name }
    manifest_name :top_comments
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
