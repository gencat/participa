# frozen_string_literal

module Decidim
  class ExternalAuthor < ActiveRecord::Base
    include Decidim::ActsAsAuthor
    belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

    validates :name, presence: true, uniqueness: { scope: :organization }

    # Returns the presenter for this author, to be used in the views.
    # Required by ActsAsAuthor.
    def presenter
      Decidim::ExternalAuthorPresenter.new(self)
    end

  end
end
