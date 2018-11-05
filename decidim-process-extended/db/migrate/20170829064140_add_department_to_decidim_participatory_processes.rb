class AddDepartmentToDecidimParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :decidim_department_id, :integer
  end
end
