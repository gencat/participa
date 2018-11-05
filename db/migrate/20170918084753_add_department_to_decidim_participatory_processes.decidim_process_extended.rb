# This migration comes from decidim_process_extended (originally 20170829064140)
class AddDepartmentToDecidimParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :decidim_department_id, :integer
  end
end
