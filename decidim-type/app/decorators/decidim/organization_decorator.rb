# frozen_string_literal: true

Decidim::Organization.class_eval do
  has_many :types, -> { order(name: :asc) }, foreign_key: "decidim_organization_id", class_name: "DecidimType", inverse_of: :organization
end
