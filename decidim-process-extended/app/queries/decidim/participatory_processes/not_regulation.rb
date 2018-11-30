# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # This query filters published processes only.
    class NotRegulation < Rectify::Query
      def query
        Decidim::ParticipatoryProcess.where("decidim_participatory_processes.decidim_participatory_process_group_id = 1 and decidim_participatory_processes.end_date >= ?", DateTime.now.to_date)
      end
    end
  end
end
