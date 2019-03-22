# frozen_string_literal: true

module Decidim
  module Regulations
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class RegulationController < Decidim::ParticipatoryProcesses::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show

      helper Decidim::AttachmentsHelper
      helper Decidim::IconHelper
      helper Decidim::WidgetUrlsHelper
      helper Decidim::SanitizeHelper

      helper_method :collection, :promoted_participatory_processes, :participatory_processes, :stats, :filter, :types, :departments
      helper_method :current_participatory_process

      def index
        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show
        enforce_permission_to :read, :process, process: current_participatory_process
      end

      private

      def filtered_participatory_processes(filter = default_filter, filter_type_filter = 0, department_type_filter = 0, status_filter = 0)
        Decidim::ParticipatoryProcesses::OrganizationPrioritizedRegulations.new(current_organization, filter, current_user, regulation, filter_type_filter, department_type_filter, status_filter)
      end

      def participatory_processes
        @participatory_processes ||= filtered_participatory_processes(filter, filter_type, theme_type, status)
      end

      def collection
        @collection ||= (participatory_processes.to_a).flatten
      end

      def promoted_participatory_processes
        @promoted_processes ||= filtered_participatory_processes | Decidim::ParticipatoryProcesses::PromotedParticipatoryProcesses.new
      end

      def participatory_process_groups
        @process_groups ||= Decidim::ParticipatoryProcesses::OrganizationPrioritizedRegulations.new(current_organization, filter, current_user, regulation)
      end

      def current_participatory_space
        return unless params[:slug].present?
        @current_participatory_space ||= collection.find_by(slug: params[:slug])
      end

      def current_participatory_process
        return unless params[:slug].present?
        @current_participatory_process ||= collection.find_by(slug: params[:slug])
      end

      def stats
        @stats ||= Decidim::ParticipatoryProcesses::ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_process)
      end

      def filter
        @filter = params[:filter] || default_filter
      end

      def regulation
        @regulation = request.original_fullpath.include? "/regulations"
      end

      def default_filter
        "active"
      end

      def types
        @types ||= ::DecidimType.all
      end

      def departments
        @departments ||= ::DecidimDepartment.all
      end

      def filter_type
        if params.has_key?(:type_id)
          @filter_type = params[:type_id]
        else
          @filter_type = 0
        end
      end

      def theme_type
        if params.has_key?(:theme_id)
          @department_type = params[:theme_id]
        else
          @department_type = 0
        end
      end

      def status
        if params.has_key?(:status)
          @status = params[:status]
        else
          @status = 0
        end
      end
    end
  end
end
