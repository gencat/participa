# frozen_string_literal: true

module Decidim
  # This controller serves static pages using HighVoltage.
  class PagesController < Decidim::ApplicationController
    layout "layouts/decidim/application"

    helper_method :page, :stats, :home_participatory_processes
    helper CtaButtonHelper
    helper Decidim::SanitizeHelper
    skip_before_action :store_current_location

    def index
      enforce_permission_to :read, :public_page
      @pages = current_organization.static_pages.sorted_by_i18n_title
    end

    def show
      enforce_permission_to :read, :public_page, page: page
			if params[:id] == "home"
				render :home
      else
        render :decidim_page
      end
    end

    def page
      @page ||= current_organization.static_pages.find_by(slug: params[:id])
    end

		def home_participatory_processes
			@home_participatory_processes ||= ParticipatoryProcess.where(organization: current_organization, show_home: true).published
		end

    private

    def stats
      @stats ||= HomeStatsPresenter.new(organization: current_organization)
    end
  end
end

# # frozen_string_literal: true
#
# require_dependency "decidim/application_controller"
# require_dependency "decidim/page_finder"
#
# module Decidim
# 	# This controller serves static pages using HighVoltage.
# 	class PagesController < ApplicationController
# 		include HighVoltage::StaticPage
#
# 		# Diría que no se usa, si es el caso eliminar junto con este comentario
# 		# helper Decidim::Admin::ResourceHelper
#
# 		layout "layouts/decidim/application"
#
# 		authorize_resource :public_pages, class: false
# 		delegate :page, to: :page_finder
# 		helper_method :page, :next_meetings, :promoted_participatory_processes, :highlighted_participatory_processes, :stats, :home_participatory_processes
# 		helper Decidim::SanitizeHelper
#
# 		def index
# 			@pages = current_organization.static_pages.all.to_a.sort do |a, b|
# 				a.title[I18n.locale.to_s] <=> b.title[I18n.locale.to_s]
# 			end
# 		end
#
# 		def page_finder
# 			@page_finder ||= Decidim::PageFinder.new(params[:id], current_organization)
# 		end
#
# 		def promoted_participatory_processes
# 			@promoted_participatory_processes ||=
# 				ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcesses.new(current_organization, "active", current_user) | ParticipatoryProcesses::PromotedParticipatoryProcesses.new
# 		end
#
# 		def highlighted_participatory_processes
# 			@highlighted_participatory_processes ||=
# 				Decidim::ParticipatoryProcess.where(organization: current_organization, decidim_participatory_process_group_id: Rails.application.config.process).where('DATE(published_at) > \'1990/01/01\'' ).order(published_at: :desc)
# 		end
#
# 		def home_participatory_processes
# 			@home_participatory_processes ||= ParticipatoryProcess.where(organization: current_organization, show_home: true).published
# 		end
#
# 		def next_meetings
# 			@next_meetings ||= Decidim::Meetings::Meeting.order("start_time ASC").limit(8)
# 		end
#
# 		private
#
# 		def stats
# 			@stats ||= HomeStatsPresenter.new(organization: current_organization)
# 		end
# 	end
# end
