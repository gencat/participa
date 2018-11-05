# frozen_string_literal: true

module Decidim
  module Admin
    # A form object to create or update departments.
    class ThemeForm < Form
      include TranslatableAttributes
      translatable_attribute :name, String
      attribute :decidim_organization_id, Decidim::Organization
      mimic :type

      validates :name, :decidim_organization_id, presence: true
      validate :name, :name_uniqueness

      alias decidim_organization_id current_organization

      private

      def name_uniqueness
        return unless decidim_organization_id && DecidimTheme.all.where(name: name).where.not(id: id).any?

        errors.add(:name, :taken)
      end
    end
  end
end
