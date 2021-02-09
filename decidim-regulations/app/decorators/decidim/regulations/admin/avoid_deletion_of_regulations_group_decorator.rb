# frozen_string_literal: true

module Decidim
  module Regulations
    module Admin
      # To avoid admin users to delete special process groups
      #
      module AvoidDeletionOfRegulationsGroup
        def destroy
          forbidden_groups_ids = [
            Rails.application.config.process.to_s,
            Rails.application.config.regulation.to_s
          ]
          if forbidden_groups_ids.include?(params[:id])
            flash[:alert] = "Protected ParticipatoryProcessGroup, can't be deleted."
            redirect_to participatory_process_groups_path
          else
            super
          end
        end
      end
    end
  end
end
