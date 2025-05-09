# frozen_string_literal: true

# This decorator add types_select to generates a select field with the types like areas_select in Decidim
module Lib::Decidim::FormBuilderDecorator
  def self.decorate
    Decidim::FormBuilder.class_eval do
      def types_select(name, collection, options = {})
        selectables = if collection.first.is_a?(Decidim::ParticipatoryProcessType)
                        collection_transformed = collection
                                                 .map { |a| [a.title[I18n.locale.to_s], a.id] }
                                                 .sort_by { |arr| arr[0] }

                        @template.options_for_select(
                          collection_transformed,
                          selected: options[:selected]
                        )
                      else
                        @template.option_groups_from_collection_for_select(
                          collection,
                          :types,
                          :translated_name,
                          :id,
                          :translated_name,
                          selected: options[:selected]
                        )
                      end

        select(name, selectables, options)
      end
    end
  end
end

Lib::Decidim::FormBuilderDecorator.decorate
