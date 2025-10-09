# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/proposals/test/factories"
require "decidim/meetings/test/factories"
require "decidim/pages/test/factories"

FactoryBot.define do
  factory :external_author, class: "Decidim::ExternalAuthor" do
    transient do
      skip_injection { false }
    end

    name { generate(:name) }
    organization
  end
end
