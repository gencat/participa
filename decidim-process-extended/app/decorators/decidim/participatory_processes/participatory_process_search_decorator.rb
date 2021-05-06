# frozen_string_literal: true

require_dependency "decidim/participatory_processes/participatory_process_search"

Decidim::ParticipatoryProcesses::ParticipatoryProcessSearch.class_eval do
  def initialize(options = {})
    super(Decidim::ParticipatoryProcess.where(decidim_participatory_process_group_id: Rails.application.config.process), options)
  end
end
