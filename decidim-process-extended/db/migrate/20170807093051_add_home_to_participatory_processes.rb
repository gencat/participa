class AddHomeToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
      add_column :decidim_participatory_processes, :show_home, :boolean, :default => false
  end
end
