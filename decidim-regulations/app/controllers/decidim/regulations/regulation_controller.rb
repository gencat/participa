# frozen_string_literal: true

module Decidim
  module Regulations
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class RegulationController < Decidim::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show

      helper Decidim::AttachmentsHelper
      helper Decidim::IconHelper
      helper Decidim::WidgetUrlsHelper
      helper Decidim::SanitizeHelper

      # helper Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper

      # layout "layouts/decidim/regulation", only: [:show]

      # before_action -> { extend NeedsParticipatoryProcess }, only: [:show]

      # helper Decidim::AttachmentsHelper
      # helper Decidim::IconHelper
      # helper Decidim::WidgetUrlsHelper
      # helper Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper

      helper_method :collection, :promoted_participatory_processes, :participatory_processes, :stats, :filter, :types, :departments, :categories, :has_debats, :is_subcategory
      helper_method :current_participatory_process

      def index
        authorize! :read, ParticipatoryProcess
        authorize! :read, ParticipatoryProcessGroup
      end

      def show
        authorize! :read, current_participatory_process
      end

      private

      def collection
        @collection ||= (participatory_processes.to_a).flatten
      end

      def filtered_participatory_processes(filter = default_filter, filter_type_filter = 0, department_type_filter = 0, status_filter = 0)
        Decidim::ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcesses.new(current_organization, filter, regulation, filter_type_filter, department_type_filter, status_filter)
      end

      def participatory_processes
        @participatory_processes ||= filtered_participatory_processes(filter, filter_type, theme_type, status)
      end

      def promoted_participatory_processes
        @promoted_processes ||= filtered_participatory_processes | Decidim::ParticipatoryProcesses::PromotedParticipatoryProcesses.new
      end

      def participatory_process_groups
        @process_groups ||= Decidim::ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcesses.new(current_organization, filter, regulation)
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

      def categories
        @categories ||= Decidim::Category.where(decidim_participatory_space_id: current_participatory_process.id, decidim_participatory_space_type: "Decidim::ParticipatoryProcess")
      end

      def has_debats(process_id)
        @has_debats ||= Decidim::Feature.where(participatory_space_id: process_id, manifest_name: "proposals").where.not(published_at: nil)
      end

      def is_subcategory(category_id)
        @is_subcategory = Decidim::Category.all.where(id: category_id).where.not(parent_id: nil).exists?
      end

    end
  end
end