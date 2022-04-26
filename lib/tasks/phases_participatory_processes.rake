# frozen_string_literal: true

namespace :phases_participatory_processes do
  desc "Change active step automatically in participatory processes"
  task :change_active_step, [] => :environment do
    Decidim::ParticipatoryProcesses::AutomateProcessesSteps.new.change_active_step
  end

  task enqueue_change_active_step: :environment, :environment do
    Decidim::ParticipatoryProcesses::ChangeActiveStepJob.perform_later
  end
end
