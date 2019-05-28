# frozen_string_literal: true

Decidim::DecidimFormHelper.class_eval do
  # Handle which collection to pass to Decidim::FilterFormBuilder.areas_select
  def types_for_select(organization)
    types = ::DecidimType.where(decidim_organization_id: organization.id)
    return unless types.any?

    types.order(:name)
  end
end
