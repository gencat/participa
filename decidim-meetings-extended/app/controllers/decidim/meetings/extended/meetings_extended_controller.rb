# frozen_string_literal: true

require_dependency "decidim/pages_controller"
module Decidim
  module Meetings
    module Extended
      class MeetingsExtendedController < Decidim::ApplicationController
        skip_authorization_check
        helper_method :show_meetings, :show_scopes, :show_selected_scopes, :show_happened, :show_date, :related_feature, :related_process, :show_processes

        helper Decidim::PaginateHelper
        helper Decidim::ResourceHelper

          def meetings
          end


          def related_meeting_feature
              @related_meeting_feature = Decidim::Feature.where(participatory_space_id: params[:related_process], manifest_name: "meetings").map(&:id)
          end
          
          def show_meetings
            #name filter
            #if it's needed, add organization filter
            if params.has_key?(:name)
              @show_meetings ||= Decidim::Meetings::Meeting.where(localized_search_text_in(:title), text: "%#{params[:name]}%").order(:start_time).page(params[:page]).per(12)
            elsif params.has_key?(:page)
              @show_meetings ||= Decidim::Meetings::Meeting.order(:start_time).page(params[:page]).per(12)
            else
              @show_meetings ||= Decidim::Meetings::Meeting.order(:start_time).page(1).per(12)
            end

            #scope filter
            # if params.has_key?(:filter)
            #   if !params[:filter].empty? && (params[:filter][:scope_id][1] != nil)
            #     @show_meetings = @show_meetings.where(decidim_scope_id: params[:filter][:scope_id])
            #   else
            #     @show_meetings = @show_meetings
            #   end
            # else
            #   @show_meetings = @show_meetings
            # end
            
            #happened filter
            if params.has_key?(:post)
              if !params[:post].empty? && params[:post][:happened][0] == "1"
                @show_meetings = @show_meetings.where("DATE(end_time) <= ?", Time.now.strftime("%Y-%m-%d")).reorder(start_time: :desc)
              else
                @show_meetings  = @show_meetings.where("DATE(start_time) >= ?", Time.now.strftime("%Y-%m-%d"))
              end
            else
              @show_meetings = @show_meetings.where("DATE(start_time) >= ?", Time.now.strftime("%Y-%m-%d"))
            end
          
            #date filter
            if params.has_key?(:date)
              if params[:date] == "1"
                @show_meetings = @show_meetings.where("DATE(start_time) <= ?", Time.now.advance(hours: 24).strftime("%Y-%m-%d"))
              elsif params[:date] == "2"
                @show_meetings = @show_meetings.where("DATE(start_time) <= ?", Time.now.advance(weeks: 1).strftime("%Y-%m-%d"))
              elsif params[:date] == "3"
                @show_meetings = @show_meetings.where("DATE(start_time) <= ?", Time.now.advance(months: 1).strftime("%Y-%m-%d"))
              else
                @show_meetings = @show_meetings
              end
            else
              @show_meetings = @show_meetings
            end

            #process filter
            if params.has_key?(:related_process)
              if params[:related_process] != "0"
                @show_meetings = @show_meetings.where(decidim_feature_id: related_meeting_feature)
              else
                @show_meetings = @show_meetings
              end
            else
              @show_meetings = @show_meetings
            end

          end

          def localized_search_text_in(field)
            current_organization.available_locales.map { |l| "#{field} ->> '#{l}' ILIKE :text" }.join(" OR ")
          end

          def show_scopes
            @show_scopes ||= Decidim::Scope.all
          end

          def show_selected_scopes
              if params.has_key?(:filter)
                @show_selected_scopes = params[:filter][:scope_id]
              else 
                  @show_selected_scopes = ""
              end
          end

          def show_happened
            if params.has_key?(:post)
              @show_happened = params[:post][:happened]
            else
              @show_happened = @show_happened
            end
          end

          def show_date
            if params.has_key?(:date)
              @show_happened = params[:date]
            else
              @show_happened = @show_happened
            end    
          end

          def related_feature(feature_id)
            @related_fature =  Decidim::Feature.all.where(id: feature_id)
          end

          def related_process(process_id)
            @related_process = Decidim::ParticipatoryProcess.where(id: process_id)
          end

          def show_processes
            @show_processes = Decidim::ParticipatoryProcess.where(decidim_participatory_process_group_id: [1])
          end
          #end of meetings section

      end
    end
  end
end