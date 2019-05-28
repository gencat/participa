# frozen_string_literal: true

module Decidim
  module Regulations
    class RegulationFiltersCell < Decidim::ViewModel
      ALL_FILTERS = %w(opened closed upcoming all).freeze

      def filter_link(filter)
        Decidim::Regulations::Engine
          .routes
          .url_helpers
          .regulation_index_path(
            filter: {
              scope_id: get_filter(:scope_id),
              type_id: get_filter(:type_id),
              date: filter
            }
          )
      end

      def current_filter
        get_filter(:date, model[:default_filter])
      end

      def get_filter(filter_name, default = nil)
        return default unless params[:filter].try(:[], filter_name)

        params[:filter][filter_name]
      end

      def filtered_processes(date_filter)
        Decidim::Regulations::RegulationSearch.new(
          date: date_filter,
          scope_id: get_filter(:scope_id),
          type_id: get_filter(:type_id),
          current_user: current_user,
          organization: current_organization
        )
      end

      def process_count_by_filter
        return @process_count_by_filter if @process_count_by_filter

        @process_count_by_filter = %w(opened closed upcoming).inject({}) do |collection_by_filter, filter_name|
          filtered_processes = filtered_processes(filter_name).results
          processes = filtered_processes
          collection_by_filter.merge(filter_name => processes.count)
        end
        @process_count_by_filter["all"] = @process_count_by_filter.values.sum
        @process_count_by_filter
      end

      def other_filters
        @other_filters ||= ALL_FILTERS - [current_filter]
      end

      def other_filters_with_value
        @other_filters_with_value ||= other_filters.select do |filter|
          process_count_by_filter[filter].positive?
        end
      end

      def should_show_tabs?
        other_filters_with_value.any? && other_filters_with_value != ["all"]
      end

      def title
        t(current_filter, scope: "decidim.regulations.regulation.filters.counters", count: process_count_by_filter[current_filter])
      end

      def filter_name(filter)
        t(filter, scope: "decidim.regulations.regulation.filters.names")
      end

      def explanation
        return if process_count_by_filter["opened"].positive?
        content_tag(
          :span,
          t(explanation_text, scope: "decidim.regulations.regulation.filters.explanations"),
          class: "muted mr-s ml-s"
        )
      end

      def explanation_text
        return "no_active" if process_count_by_filter["upcoming"].positive?
        "no_active_nor_upcoming"
      end
    end
  end
end
