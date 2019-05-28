# frozen_string_literal: true

Decidim::FilterFormBuilder.class_eval do
  def types_select(method, collection, options = {})
    fieldset_wrapper options[:legend_title] do
      super(method, collection, options)
    end
  end
end
