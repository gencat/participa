# frozen_string_literal: true

require_dependency "decidim/application_controller"
require_dependency "decidim/page_finder"

module Decidim
    # This controller serves static pages using HighVoltage.
    class PagesController < ApplicationController
        include HighVoltage::StaticPage
        
        # Diría que no se usa, si es el caso eliminar junto con este comentario
        # helper Decidim::Admin::ResourceHelper

        layout "layouts/decidim/application"

        authorize_resource :public_pages, class: false
        delegate :page, to: :page_finder
        helper_method :page, :next_meetings, :promoted_participatory_processes, :highlighted_participatory_processes, :stats, :home_participatory_processes, :searchProcesses, :searchFeatures, :searchMeetings, :searchRegulations, :searchAssemblies
        helper Decidim::SanitizeHelper
        
        def index
            @pages = current_organization.static_pages.all.to_a.sort do |a, b|
                a.title[I18n.locale.to_s] <=> b.title[I18n.locale.to_s]
            end
        end

        def page_finder
            @page_finder ||= Decidim::PageFinder.new(params[:id], current_organization)
        end

        def promoted_participatory_processes
            @promoted_participatory_processes ||=
                ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcesses.new(current_organization) | ParticipatoryProcesses::PromotedParticipatoryProcesses.new
        end

        # origina methods
        # def highlighted_participatory_processes
        #     @highlighted_participatory_processes ||=
        #         ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses.new(current_organization) | ParticipatoryProcesses::HighlightedParticipatoryProcesses.new
        # end

        def highlighted_participatory_processes
            @highlighted_participatory_processes ||=
                Decidim::ParticipatoryProcess.where(organization: current_organization, decidim_participatory_process_group_id: Rails.application.config.process).where('DATE(published_at) > \'1990/01/01\'' ).order(published_at: :desc)
        end

        def home_participatory_processes
            @home_participatory_processes ||= ParticipatoryProcess.where(organization: current_organization, show_home: true).published
        end

        def next_meetings
            @next_meetings ||= Decidim::Meetings::Meeting.order("start_time ASC").limit(8)
        end

        private

        def stats
            @stats ||= HomeStatsPresenter.new(organization: current_organization)
        end

        def searchRegulations
            @searchRegulations ||= Decidim::ParticipatoryProcess.where(organization: current_organization, decidim_participatory_process_group_id: Rails.application.config.regulation).where('DATE(published_at) > \'1990/01/01\'' ).order(published_at: :desc).limit(8)
        end

        # def searchProcesses
        #     @searchProcesses = ParticipatoryProcess.where(decidim_participatory_process_group_id: Rails.application.config.process, organization: current_organization).published.where.not(published_at: nil).limit(8)
        # end

        def searchProcesses
            @searchProcesses = ParticipatoryProcess.where("decidim_participatory_processes.decidim_participatory_process_group_id = 1 and decidim_participatory_processes.end_date >= ?", DateTime.now.to_date).published.where.not(published_at: nil).limit(8)
        end

        def searchFeatures(process_id)
            @searchFeatures = Decidim::Feature.all.where(decidim_participatory_process_id: process_id, manifest_name: "meetings").where.not(published_at: nil).limit(8)
        end

        def searchMeetings(features_id)
            @searchMeetings = Decidim::Meetings::Meeting.where(decidim_feature_id: features_id).limit(8)
        end

        def searchAssemblies
            @searchAssemblies = Decidim::Assembly.where("decidim_organization_id = ?", current_organization).where.not(published_at: nil).order("created_at DESC").limit(8)
        end
    end
end