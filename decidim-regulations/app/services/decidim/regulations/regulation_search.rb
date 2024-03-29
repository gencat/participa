# frozen_string_literal: true

module Decidim
  module Regulations
    # Service that encapsulates all logic related to filtering participatory processes.
    class RegulationSearch < ParticipatorySpaceSearch
      def initialize(options = {})
        super(ParticipatoryProcess.where(decidim_participatory_process_group_id: Rails.application.config.regulation), options)
      end

      def search_date
        case date
        when "opened"
          query.active.order(start_date: :desc)
        when "closed"
          query.past.order(end_date: :desc)
        when "upcoming"
          query.upcoming.order(start_date: :asc)
        else # Assume 'all'
          current_zone = ActiveSupport::TimeZone.find_tzinfo(Time.zone.name).identifier
          query.order(Arel.sql("ABS(start_date - (CURRENT_DATE at time zone '#{current_zone}')::date)"))
        end
      end

      def search_type_id
        query.includes(:decidim_type).where(decidim_type_id: type_id)
      end
    end
  end
end
