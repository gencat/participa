class RemoveDecidimTypeIdInParticipatoryProcesses < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_participatory_processes, :decidim_type_id
  end
end
