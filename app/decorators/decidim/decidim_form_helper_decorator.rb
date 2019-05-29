# frozen_string_literal: true

Decidim::DecidimFormHelper.class_eval do
  # Handle which collection to pass to Decidim::FilterFormBuilder.types_select
  def types_for_select(organization)
    return organization.types if organization.types.any?
  end
end
