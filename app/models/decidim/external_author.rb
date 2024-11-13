# frozen_string_literal: true

module Decidim
  class ExternalAuthor < ApplicationRecord
    include Decidim::ActsAsAuthor
    include Decidim::Followable

    belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

    validates :name, presence: true, uniqueness: { scope: :organization }

    def presenter
      Decidim::ExternalAuthorPresenter.new(self)
    end
  end
end
