class RenameThemeIdColumnInParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    rename_column :decidim_participatory_processes, :theme_id, :decidim_theme_id
  end
end
