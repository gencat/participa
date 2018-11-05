class AddThemeColumnToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :theme_id, :integer
  end
end
