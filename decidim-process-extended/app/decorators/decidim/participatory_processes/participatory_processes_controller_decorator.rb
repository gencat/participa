# frozen_string_literal: true

Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.class_eval do
  def published_processes
    # must return a Rectify::Query because later the Rectify::Query#| method is called, which is different from Array or ActiveRecord::Relation#|
    @published_processes ||= Rectify::Query.new(
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
    search.results.where(decidim_participatory_process_group_id: Rails.application.config.process)
  end

  # This is customized because GENCAT
  def participatory_processes
    @participatory_processes ||= filtered_processes
  end
  # This is customized because GENCAT
end
