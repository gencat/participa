# frozen_string_literal: true

module Decidim
  module Regulations
    # Service that encapsulates all logic related to filtering participatory processes.
    class RegulationSearch < ParticipatorySpaceSearch
      def initialize(options = {})
        super(ParticipatoryProcess.all, options).where(decidim_participatory_process_group_id: Rails.application.config.process)
      end

      def search_date
        case date
        when "opened"
          query.active.where("decidim_participatory_processes.start_date < ? AND decidim_participatory_processes.end_date > date(?)", DateTime.now.to_date, DateTime.now.to_date).order(start_date: :desc)
        when "closed"
          query.past.order(end_date: :desc)
        when "upcoming"
          query.upcoming.order(start_date: :asc)
        else # Assume 'all'
          current_zone = Time.zone.name
          query.order(Arel.sql("ABS(start_date - (CURRENT_DATE at time zone '#{current_zone}')::date)"))
        end
      end
    end
  end
end
