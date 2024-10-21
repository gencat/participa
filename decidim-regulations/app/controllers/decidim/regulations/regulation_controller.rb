# frozen_string_literal: true

module Decidim
  module Regulations
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class RegulationController < Decidim::ParticipatoryProcesses::ApplicationController
      include ParticipatorySpaceContext
      include FilterResource

      participatory_space_layout only: [:show, :all_metrics]

      helper_method :collection,
                    :promoted_collection,
                    :participatory_processes,
                    :stats,
                    :metrics,
                    :participatory_process_group,
                    :default_date_filter,
                    :related_processes,
                    :linked_assemblies

      def index
        raise ActionController::RoutingError, "Not Found" if published_processes.none?

        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show
        enforce_permission_to :read, :process, process: current_participatory_process
      end

      def all_metrics
        if current_participatory_space.show_statistics
          enforce_permission_to :read, :process, process: current_participatory_space
        else
          render status: :not_found
        end
      end

      private

      def search_collection
        ParticipatoryProcess.where(organization: current_organization,
                                   decidim_participatory_process_group_id: Rails.application.config.regulation).published.visible_for(current_user).includes(:area)
      end

      def default_filter_params
        {
          with_any_scope: nil,
          with_type: nil,
          with_date: default_date_filter
        }
      end

      def organization_participatory_processes
        @organization_participatory_processes ||= Decidim::ParticipatoryProcesses::OrganizationParticipatoryProcesses
                                                  .new(current_organization)
                                                  .query
                                                  .where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      def current_participatory_space
        return unless params["slug"]

        @current_participatory_space ||= organization_participatory_processes.where(slug: params["slug"]).or(
          organization_participatory_processes.where(id: params["slug"])
        ).first!
      end

      def published_processes
        @published_processes ||= Decidim::ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses
                                 .new(current_organization, current_user)
                                 .query
                                 .where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      def promoted_participatory_processes
        @promoted_participatory_processes ||= published_processes.promoted
      end

      def promoted_participatory_process_groups
        @promoted_participatory_process_groups ||=
          Decidim::ParticipatoryProcesses::OrganizationPromotedParticipatoryProcessGroups.new(current_organization)
                                                                                         .query.where(id: [Rails.application.config.regulation])
      end

      def promoted_collection
        @promoted_collection ||= promoted_participatory_processes + promoted_participatory_process_groups
      end

      # This is customized because GENCAT don't Processes Groups on Index Page
      def collection
        @collection ||= participatory_processes
      end
      # This is customized because GENCAT don't Processes Groups on Index Page

      def filtered_processes
        search.result.where(decidim_participatory_process_group_id: Rails.application.config.regulation)
      end

      # This is customized because GENCAT
      def participatory_processes
        @participatory_processes ||= filtered_processes.includes(attachments: :file_attachment)
      end
      # This is customized because GENCAT

      def participatory_process_groups
        @participatory_process_groups ||= Decidim::ParticipatoryProcesses::OrganizationParticipatoryProcessGroups.new(current_organization).query
                                                                                                                 .where(id: filtered_processes.grouped.group_ids)
      end

      def stats
        @stats ||= ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_space)
      end

      def metrics
        @metrics ||= ParticipatoryProcessMetricChartsPresenter.new(participatory_process: current_participatory_space)
      end

      def participatory_process_group
        @participatory_process_group ||= current_participatory_space.participatory_process_group
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

      def linked_assemblies
        @linked_assemblies ||= current_participatory_space.linked_participatory_space_resources(:assembly, "included_participatory_processes").public_spaces
      end
    end
  end
end
