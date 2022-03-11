# frozen_string_literal: true

FactoryBot.define do
  factory :type, class: "DecidimType" do
    name { generate_localized_title }
    organization
  end
end
