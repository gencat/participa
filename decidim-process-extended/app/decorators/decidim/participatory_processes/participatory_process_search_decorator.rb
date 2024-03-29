# frozen_string_literal: true

require_dependency "decidim/participatory_processes/participatory_process_search"

Decidim::ParticipatoryProcesses::ParticipatoryProcessSearch.class_eval do
  def initialize(options = {})
    base_relation = if options.has_key?(:base_relation)
                      options.delete(:base_relation)
                    else
                      Decidim::ParticipatoryProcess.where(decidim_participatory_process_group_id: Rails.application.config.process)
                    end
    super(base_relation, options)
  end
end
