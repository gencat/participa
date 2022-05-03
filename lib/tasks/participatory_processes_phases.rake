# frozen_string_literal: true

namespace :participatory_processes_phases do
  desc "Force changing active steps in participatory processes"
  task :change_active_step, [] => :environment do
    Decidim::ParticipatoryProcesses::AutomateProcessesSteps.new.change_active_step
  end

  task enqueue_change_active_step: :environment do
    Decidim::ParticipatoryProcesses::ChangeActiveStepJob.perform_later
  end
end
