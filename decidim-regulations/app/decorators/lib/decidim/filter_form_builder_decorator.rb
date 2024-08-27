# frozen_string_literal: true

# This decorator add the method types_select to wrap the types select
# in a custom fieldset like categories or areas in Decidim.
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
