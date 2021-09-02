class RemoveHomeToParticipatoryProcesses < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_participatory_processes, :show_home
  end
end
