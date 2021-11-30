class RemoveDecidimCustomCategorizationTablesAfterMigrateToDecidimStandards < ActiveRecord::Migration[5.2]
  def change

    # Drop tables
    drop_table :decidim_departments
    drop_table :decidim_themes

    # Drop columns from surveys table
    remove_column :decidim_participatory_processes, :decidim_department_id
    remove_column :decidim_participatory_processes, :decidim_theme_id

  end
end
