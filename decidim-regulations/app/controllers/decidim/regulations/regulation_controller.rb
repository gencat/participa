# frozen_string_literal: true

module Decidim
  module Regulations
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class RegulationController < Decidim::ParticipatoryProcesses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: [:show, :all_metrics]
      include FilterResource

      helper_method :collection,
                    :promoted_participatory_processes,
                    :participatory_processes,
                    :stats,
                    :metrics,
                    :default_date_filter,
                    :related_processes

      def index
        raise ActionController::RoutingError, "Not Found" if published_processes.none?

        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show
        enforce_permission_to :read, :process, process: current_participatory_process
      end

      def all_metrics
        enforce_permission_to :read, :process, process: current_participatory_space
      end

      private

      def search_klass
        RegulationSearch
      end

      def default_filter_params
        {
          scope_id: nil,
          type_id: nil,
          date: default_date_filter
        }
      end

      def organization_participatory_processes
        @organization_participatory_processes ||= Decidim::ParticipatoryProcesses::OrganizationParticipatoryProcesses.new(current_organization).query.where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      def current_participatory_space
        return unless params["slug"]

        @current_participatory_space ||= organization_participatory_processes.where(slug: params["slug"]).or(
          organization_participatory_processes.where(id: params["slug"])
        ).first!
      end

      def published_processes
        @published_processes ||= Decidim::ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user).query.where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      def promoted_participatory_processes
        @promoted_participatory_processes ||= published_processes.promoted
      end

      # This is customized because GENCAT don't Processes Groups on Index Page
      def collection
        @collection ||= participatory_processes
      end
      # This is customized because GENCAT don't Processes Groups on Index Page

      def filtered_processes
        search.results.where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      # This is customized because GENCAT
      def participatory_processes
        @participatory_processes ||= filtered_processes
      end
      # This is customized because GENCAT

      def participatory_process_groups
        @participatory_process_groups ||= Decidim::ParticipatoryProcessGroup
                                          .where(id: filtered_processes.grouped.group_ids)
      end

      def stats
        @stats ||= ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_space)
      end

      def metrics
        @metrics ||= ParticipatoryProcessMetricChartsPresenter.new(participatory_process: current_participatory_space)
      end

      def default_date_filter
        return "opened" if published_processes.any?(&:active?)
        return "closed" if published_processes.any?(&:past?)
        return "upcoming" if published_processes.any?(&:upcoming?)

        "all"
      end

      def related_processes
        @related_processes ||=
          current_participatory_space
          .linked_participatory_space_resources(:participatory_processes, "related_processes")
          .published
          .all
      end
    end
  end
end
