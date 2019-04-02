# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # This query class filters participatory processes given a filter name.
    # It uses the start and end dates to select the correct processes.
    class FilteredParticipatoryProcesses < Rectify::Query
      def initialize(filter = "active", regulation = false, filter_type = 0, theme_type = 0, status = 0)
        @filter = filter
        @regulation = regulation
        @filter_type = filter_type
        @theme_type = theme_type
        @status = status
      end

      def query
        processes = Decidim::ParticipatoryProcess.all

        if @regulation == true
            if (@filter_type == 0 && @theme_type == 0) || (@filter_type == "0" && @theme_type == "0")
                if @status == 0 || @status == "0"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?", Rails.application.config.regulation)
                elsif @status == 1 || @status == "1"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND ( decidim_participatory_processes.start_date > ? OR decidim_participatory_processes.end_date < date(?))", Rails.application.config.regulation, DateTime.now.to_date, DateTime.now.to_date)
                elsif @status == 2 || @status == "2"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND ( decidim_participatory_processes.start_date < ? AND decidim_participatory_processes.end_date > date(?))", Rails.application.config.regulation, DateTime.now.to_date, DateTime.now.to_date)
                end
            elsif (@filter_type == "0" && @theme_type != "0")
                if @status == 0 || @status == "0"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_theme_id = ?", Rails.application.config.regulation, @theme_type)
                elsif @status == 1 || @status == "1"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_theme_id = ? AND ( decidim_participatory_processes.start_date > ? OR decidim_participatory_processes.end_date < date(?))", Rails.application.config.regulation, @theme_type, DateTime.now.to_date, DateTime.now.to_date)
                elsif @status == 2 || @status == "2"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_theme_id = ? AND ( decidim_participatory_processes.start_date < ? AND decidim_participatory_processes.end_date > date(?))", Rails.application.config.regulation, @theme_type, DateTime.now.to_date, DateTime.now.to_date)
                end
            elsif (@filter_type != "0" && @theme_type == "0")
                if @status == 0 || @status == "0"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ?", Rails.application.config.regulation, @filter_type)
                elsif @status == 1 || @status == "1"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ? AND ( decidim_participatory_processes.start_date > ? OR decidim_participatory_processes.end_date < date(?))", Rails.application.config.regulation, @filter_type, DateTime.now.to_date, DateTime.now.to_date)
                elsif @status == 2 || @status == "2"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ? AND ( decidim_participatory_processes.start_date < ? AND decidim_participatory_processes.end_date > date(?))", Rails.application.config.regulation, @filter_type, DateTime.now.to_date, DateTime.now.to_date)
                end
            else
                if @status == 0 || @status == "0"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ? AND decidim_participatory_processes.decidim_theme_id = ?", Rails.application.config.regulation, @filter_type, @theme_type)
                elsif @status == 1 || @status == "1"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ? AND decidim_participatory_processes.decidim_theme_id = ? AND ( decidim_participatory_processes.start_date > ? OR decidim_participatory_processes.end_date < date(?))", Rails.application.config.regulation, @filter_type, @theme_type, DateTime.now.to_date, DateTime.now.to_date)
                elsif @status == 2 || @status == "2"
                    processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ? AND decidim_participatory_processes.decidim_type_id = ? AND decidim_participatory_processes.decidim_theme_id = ? AND ( decidim_participatory_processes.start_date < ? AND decidim_participatory_processes.end_date > date(?))", Rails.application.config.regulation, @filter_type, @theme_type, DateTime.now.to_date, DateTime.now.to_date)
                end
            end
        else
          case @filter
          when "all"
            processes.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?",  Rails.application.config.process)
          when "past"
            processes.past.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?",  Rails.application.config.process)
          when "upcoming"
            processes.upcoming.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?",  Rails.application.config.process)
          else
            processes.active.where("decidim_participatory_processes.decidim_participatory_process_group_id = ?",  Rails.application.config.process)
          end
        end
      end
    end
  end
end
