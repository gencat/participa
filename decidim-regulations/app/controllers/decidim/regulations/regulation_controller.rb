# frozen_string_literal: true

module Decidim
  module Regulations
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class RegulationController < Decidim::ParticipatoryProcesses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: [:show, :statistics]

      include FilterResource

      helper_method :collection, :promoted_participatory_processes, :participatory_processes, :stats, :metrics, :default_date_filter
      # helper_method :current_participatory_process

      def index
        raise ActionController::RoutingError, "Not Found" if published_processes.none?

        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show
        enforce_permission_to :read, :process, process: current_participatory_process
      end

      def statistics
        enforce_permission_to :read, :process, process: current_participatory_space
      end

      private

      def search_klass
        RegulationSearch
      end

      def default_filter_params
        {
          scope_id: nil,
          area_id: nil,
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
        return "opened" if published_processes.where("start_date < ? AND end_date > date(?)", DateTime.now.to_date, DateTime.now.to_date).order(start_date: :desc).any?(&:active?)
        return "closed" if published_processes.any?(&:past?)
        return "upcoming" if published_processes.any?(&:upcoming?)
        "all"
      end

      # def filtered_participatory_processes(filter = default_filter, filter_type_filter = 0, department_type_filter = 0, status_filter = 0)
      #   Decidim::ParticipatoryProcesses::OrganizationPrioritizedRegulations.new(current_organization, filter, current_user, regulation, filter_type_filter, department_type_filter, status_filter)
      # end
      #
      # def participatory_processes
      #   @participatory_processes ||= filtered_participatory_processes(filter, filter_type, theme_type, status)
      # end
      #
      # def collection
      #   @collection ||= (participatory_processes.to_a).flatten
      # end
      #
      # def promoted_participatory_processes
      #   @promoted_processes ||= filtered_participatory_processes | Decidim::ParticipatoryProcesses::PromotedParticipatoryProcesses.new
      # end
      #
      # def participatory_process_groups
      #   @process_groups ||= Decidim::ParticipatoryProcesses::OrganizationPrioritizedRegulations.new(current_organization, filter, current_user, regulation)
      # end
      #
      # def current_participatory_space
      #   return unless params[:slug].present?
      #   @current_participatory_space ||= collection.find_by(slug: params[:slug])
      # end
      #
      # def current_participatory_process
      #   return unless params[:slug].present?
      #   @current_participatory_process ||= collection.find_by(slug: params[:slug])
      # end
      #
      # def stats
      #   @stats ||= Decidim::ParticipatoryProcesses::ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_process)
      # end
      #
      # def filter
      #   @filter = params[:filter] || default_filter
      # end
      #
      # def regulation
      #   @regulation = request.original_fullpath.include? "/regulations"
      # end
      #
      # def default_filter
      #   "active"
      # end
      #
      # def types
      #   @types ||= Decidim::Scope.where(scope_type: Decidim::ScopeType.find_by(id: 3))
      # end
      #
      # def departments
      #   @departments ||= Decidim::Area.all
      # end
      #
      # def filter_type
      #   if params.has_key?(:type_id)
      #     @filter_type = params[:type_id]
      #   else
      #     @filter_type = 0
      #   end
      # end
      #
      # def theme_type
      #   if params.has_key?(:theme_id)
      #     @department_type = params[:theme_id]
      #   else
      #     @department_type = 0
      #   end
      # end
      #
      # def status
      #   if params.has_key?(:status)
      #     @status = params[:status]
      #   else
      #     @status = 2
      #   end
      # end
    end
  end
end
