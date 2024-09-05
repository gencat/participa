class ChangeTypesInParticipatoryProcesses < ActiveRecord::Migration[6.1]
  class DecidimType < ApplicationRecord; end

  # Change decidim type by participatory process type in participatory processes
  def change
    previous_regulation_type = DecidimType.find(1)
    initial_regulation_type = DecidimType.find(2)

    ppt_previous_regulation_type = Decidim::ParticipatoryProcessType.find_by(title: previous_regulation_type.name)
    ppt_initial_regulation_type = Decidim::ParticipatoryProcessType.find_by(title: initial_regulation_type.name)

    Decidim::ParticipatoryProcess.find_each do |participatory_process|
      begin
        next if participatory_process.decidim_type_id.nil?
        
        if participatory_process.decidim_type_id == previous_regulation_type.id
          participatory_process.update(participatory_process_type: ppt_previous_regulation_type)
        else
          participatory_process.update(participatory_process_type: ppt_initial_regulation_type)
        end
      rescue StandardError => e
        puts "There is an error updating participatory process with ID #{participatory_process.id}"
        puts "ERROR #{e}"
      end
    end
  end
end
