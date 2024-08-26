# frozen_string_literal: true

# Add types_select method to show a select for types in
module Decidim::FilterFormBuilderDecorator
  def self.decorate
    Decidim::FilterFormBuilder.class_eval do
      def types_select(method, collection, options = {})
        fieldset_wrapper(options[:legend_title], "#{method}_types_select_filter") do
          super(method, collection, options)
        end
      end
    end
  end
end

::Decidim::FilterFormBuilderDecorator.decorate
