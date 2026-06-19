# frozen_string_literal: true

module Decidim
  module Regulations
    module RegulationHelper
      def filter_sections
        items = [
          { method: :with_date, collection: filter_dates_values, label: t("decidim.participatory_processes.participatory_processes.filters.date"), id: "date" }
        ]
        available_taxonomy_filters.find_each do |taxonomy_filter|
          items.append(method: "with_any_taxonomies[#{taxonomy_filter.root_taxonomy_id}]",
                       collection: filter_taxonomy_values_for(taxonomy_filter),
                       label: decidim_sanitize_translated(taxonomy_filter.name),
                       id: "taxonomy")
        end
        items.reject { |item| item[:collection].blank? }
      end

      def filter_dates_values
        [
          ["all", t("all", scope: "decidim.regulations.regulations.filters")],
          ["active", t("opened", scope: "decidim.regulations.regulations.filters")],
          ["past", t("closed", scope: "decidim.regulations.regulations.filters")]
        ]
      end
    end
  end
end
