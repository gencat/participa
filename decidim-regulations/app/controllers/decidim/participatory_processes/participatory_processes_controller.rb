# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # A controller that holds the logic to show ParticipatoryProcesses in a
    # public layout.
    class ParticipatoryProcessesController < Decidim::ApplicationController
      include ParticipatorySpaceContext
      participatory_space_layout only: :show

      helper Decidim::AttachmentsHelper
      helper Decidim::IconHelper
      helper Decidim::WidgetUrlsHelper
      helper Decidim::SanitizeHelper
      helper Decidim::ResourceReferenceHelper
      helper Decidim::ResourceHelper
      helper ParticipatoryProcessHelper

      helper_method :collection, :promoted_participatory_processes, :participatory_processes, :stats, :filter, :categories, :has_debats, :is_subcategory

      def index
        redirect_to "/404" if published_processes.none?

        enforce_permission_to :list, :process
        enforce_permission_to :list, :process_group
      end

      def show; end

      private

      def organization_participatory_processes
        @organization_participatory_processes ||= OrganizationParticipatoryProcesses.new(current_organization).query
      end

      def current_participatory_space
        return unless params["slug"]

        @current_participatory_space ||= organization_participatory_processes.where(slug: params["slug"]).or(
          organization_participatory_processes.where(id: params["slug"])
        ).first!
      end

      def published_processes
        @published_processes ||= OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user)
      end

      def collection
        @collection ||= (participatory_processes.to_a + participatory_process_groups).flatten
      end

      def filtered_participatory_processes(filter = default_filter)
        OrganizationPrioritizedParticipatoryProcesses.new(current_organization, filter, current_user)
      end

      def participatory_processes
        @participatory_processes ||= filtered_participatory_processes(filter)
      end

      def promoted_participatory_processes
        @promoted_processes ||= filtered_participatory_processes | PromotedParticipatoryProcesses.new
      end

      def participatory_process_groups
        @process_groups ||= OrganizationPrioritizedParticipatoryProcessGroups.new(current_organization, filter)
      end

      def stats
        @stats ||= ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_space)
      end

      def filter
        @filter = params[:filter] || default_filter
      end

      def default_filter
        "active"
      end

      def categories
        @categories ||= Decidim::Category.where(decidim_participatory_space_id: current_participatory_space.id, decidim_participatory_space_type: "Decidim::ParticipatoryProcess")
      end

      def has_debats(process_id)
        @has_debats ||= Decidim::Component.where(participatory_space_id: process_id, manifest_name: "proposals").where.not(published_at: nil)
      end

      def is_subcategory(category_id)
        @is_subcategory = Decidim::Category.all.where(id: category_id).where.not(parent_id: nil).exists?
      end
    end
  end
end

#
# module Decidim
#   module ParticipatoryProcesses
#     # A controller that holds the logic to show ParticipatoryProcesses in a
#     # public layout.
#     class ParticipatoryProcessesController < Decidim::ParticipatoryProcesses::ApplicationController
#       include ParticipatorySpaceContext
#       participatory_space_layout only: :show
#       helper Decidim::AttachmentsHelper
#       helper Decidim::IconHelper
#       helper Decidim::WidgetUrlsHelper
#       helper Decidim::SanitizeHelper
#       helper Decidim::ResourceReferenceHelper
#
#       helper ParticipatoryProcessHelper
#
#       helper_method :collection, :promoted_participatory_processes, :participatory_processes, :stats, :filter, :categories, :has_debats, :is_subcategory
#       # helper_method :current_participatory_process
#
#       def index
#         authorize! :read, ParticipatoryProcess
#         authorize! :read, ParticipatoryProcessGroup
#       end
#
#       def show
#         authorize! :read, current_participatory_process
#       end
#
#       private
#
#       def organization_participatory_processes
#         @organization_participatory_processes ||= OrganizationParticipatoryProcesses.new(current_organization).query
#       end
#
#       def current_participatory_space
#         return unless params["slug"]
#
#          @current_participatory_space ||= organization_participatory_processes.where(slug: params["slug"]).or(
#           organization_participatory_processes.where(id: params["slug"])
#         ).first!
#       end
#
#       def current_participatory_process
#         return unless params["slug"]
#
#         @current_participatory_process ||= organization_participatory_processes.where(slug: params["slug"]).or(
#          organization_participatory_processes.where(id: params["slug"])
#        ).first!
#       end
#
#       def published_processes
#         @published_processes ||= OrganizationPublishedParticipatoryProcesses.new(current_organization)
#       end
#
#       def collection
#         @collection ||= (participatory_processes.to_a).flatten
#       end
#
#       def filtered_participatory_processes(filter = default_filter)
#         OrganizationPrioritizedParticipatoryProcesses.new(current_organization, filter)
#       end
#
#       def participatory_processes
#         @participatory_processes ||= filtered_participatory_processes(filter)
#       end
#
#       def promoted_participatory_processes
#         @promoted_processes ||= filtered_participatory_processes | PromotedParticipatoryProcesses.new
#       end
#
#       def participatory_process_groups
#         @process_groups ||= OrganizationPrioritizedParticipatoryProcessGroups.new(current_organization, filter)
#       end
#
#       def stats
#         @stats ||= ParticipatoryProcessStatsPresenter.new(participatory_process: current_participatory_process)
#       end
#
#       def filter
#         @filter = params[:filter] || default_filter
#       end
#
#       def default_filter
#         "active"
#       end
#
#       def categories
#         @categories ||= Decidim::Category.where(decidim_participatory_space_id: current_participatory_process.id, decidim_participatory_space_type: "Decidim::ParticipatoryProcess")
#       end
#
#       def has_debats(process_id)
#         @has_debats ||= Decidim::Feature.where(participatory_space_id: process_id, manifest_name: "proposals").where.not(published_at: nil)
#       end
#
#       def is_subcategory(category_id)
#         @is_subcategory = Decidim::Category.all.where(id: category_id).where.not(parent_id: nil).exists?
#       end
#     end
#   end
# end
