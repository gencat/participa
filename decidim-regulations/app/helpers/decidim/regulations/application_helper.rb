module Decidim
  module Regulations
    module ApplicationHelper
      # Helper for participatory_processes show view
      def is_regulation(process_id)
        @is_regulation = (Decidim::ParticipatoryProcess.where(id: process_id).pluck(:decidim_participatory_process_group_id).first() == Rails.application.config.regulation)
      end
    end
  end
end
