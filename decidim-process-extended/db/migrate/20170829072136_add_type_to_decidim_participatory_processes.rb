class AddTypeToDecidimParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :decidim_type_id, :integer
  end
end
