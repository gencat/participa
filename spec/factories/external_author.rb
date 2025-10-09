FactoryBot.define do
  factory :external_author, class: "Decidim::ExternalAuthor" do
    transient do
      skip_injection { false }
    end

    name { generate(:name) }
    organization
  end
end
