# frozen_string_literal: true

require "decidim/participatory_processes/participatory_process_helper"

Decidim::ParticipatoryProcesses::ParticipatoryProcessHelper.class_eval do
  # Public: Returns the path for the participatory process cta button
  #
  # Returns a String with path.
  def participatory_process_cta_path(process)
    return decidim_participatory_processes.participatory_process_path(process) if process.active_step&.cta_path.blank?

    path, params = decidim_participatory_processes.participatory_process_path(process).split("?")

    "#{path}/#{process.active_step.cta_path}" + (params.present? ? "?#{params}" : "")
  end
end
