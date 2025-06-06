class ChangeTypesInParticipatoryProcesses < ActiveRecord::Migration[6.1]
  class DecidimType < ApplicationRecord; end

  # Change decidim type by participatory process type in participatory processes
  def up
    return if Rails.env.test?

    previous_regulation_type = DecidimType.find_by(name: {"ca"=>"Consulta prèvia a l'elaboració de la norma", "es"=>"Consulta previa a la elaboración de la norma", "oc"=>"Consulta prèvia a l'elaboració de la norma"})
    initial_regulation_type = DecidimType.find_by(name: {"ca"=>"Consulta sobre projecte normatiu inicial", "es"=>"Consulta sobre el proyecto normativo inicial", "oc"=>"Consulta sobre projecte normatiu inicial"})

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
