# frozen_string_literal: true

# To avoid admin users to delete special process groups

module Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessGroupsControllerDecorator
  #
  # Decorate to avoid admin users to delete special process groups
  #
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessGroupsController.class_eval do

      alias_method :original_destroy, :destroy

      def destroy
        byebug
        forbidden_groups_ids = [
          Rails.application.config.process.to_s,
          Rails.application.config.regulation.to_s
        ]
        if forbidden_groups_ids.include?(params[:id])
          flash[:alert] = "Protected ParticipatoryProcessGroup, can't be deleted."
          redirect_to participatory_process_groups_path
        else
          original_destroy
        end
      end
    end
  end
end

::Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessGroupsControllerDecorator.decorate
