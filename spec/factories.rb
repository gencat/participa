# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/participatory_processes/test/factories"
require "decidim/proposals/test/factories"
require "decidim/meetings/test/factories"

FactoryBot.define do
  factory :type, class: "DecidimType" do
    name { generate_localized_title }
    organization
  end
end
