# frozen_string_literal: true

module Decidim
  module Regulations
    module RegulationHelper
      def filter_sections
        [
          { method: :with_date, collection: filter_dates_values, label_scope: "decidim.participatory_processes.participatory_processes.filters", id: "date" },
          { method: :with_any_scope, collection: filter_global_scopes_values, label_scope: "decidim.shared.participatory_space_filters.filters", id: "scope" },
          { method: :with_any_area, collection: filter_areas_values, label_scope: "decidim.shared.participatory_space_filters.filters", id: "area" },
          { method: :with_any_type, collection: filter_types_values, label_scope: "decidim.participatory_processes.participatory_processes.filters", id: "type" }
        ].reject { |item| item[:collection].blank? }
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
