# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::ParticipatoryProcessesControllerDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.class_eval do
      def published_processes
        # must return a Decidim::Query because later the Decidim::Query#| method is called, which is different from Array or ActiveRecord::Relation#|
        @published_processes ||= Decidim::Query.new(
          Decidim::ParticipatoryProcesses::OrganizationPublishedParticipatoryProcesses.new(current_organization, current_user)
          .query.where(decidim_participatory_process_group_id: Rails.application.config.process)
        )
      end

      # This is customized because GENCAT don't Processes Groups on Index Page
      def collection
        @collection ||= participatory_processes
      end
      # This is customized because GENCAT don't Processes Groups on Index Page

      def filtered_processes
        search.result.where(decidim_participatory_process_group_id: Rails.application.config.process)
      end

      # This is customized because GENCAT
      def participatory_processes
        @participatory_processes ||= filtered_processes.includes(attachments: :file_attachment)
      end
      # This is customized because GENCAT
    end
  end
end

::Decidim::ParticipatoryProcesses::ParticipatoryProcessesControllerDecorator.decorate
