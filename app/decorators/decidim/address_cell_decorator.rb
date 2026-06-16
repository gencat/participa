# frozen_string_literal: true

# Makes the address text a clickable Google Maps link when the resource has a
# google_maps_url set. Applies to any resource using the decidim/address cell,
# guarded by respond_to? so non-meeting resources are unaffected.
# Overrides Decidim::AddressCell#address.
# Original: decidim_fork/decidim-core/app/cells/decidim/address_cell.rb
module Decidim::AddressCellDecorator
  def self.decorate
    Decidim::AddressCell.class_eval do
      alias_method :address_without_google_maps_url, :address

      def address
        text = address_without_google_maps_url
        return text unless model.respond_to?(:google_maps_url) && model.google_maps_url.present?

        url = ERB::Util.html_escape(model.google_maps_url)
        "<a class=\"button__text-secondary\" href=\"#{url}\" target=\"_blank\" rel=\"noopener noreferrer\" data-external-link=\"false\">#{text}</a>".html_safe
      end
    end
  end
end

Decidim::AddressCellDecorator.decorate
