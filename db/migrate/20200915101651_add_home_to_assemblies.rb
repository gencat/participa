class AddHomeToAssemblies < ActiveRecord::Migration[5.1]
  def change
      add_column :decidim_assemblies, :show_home, :boolean, :default => false
  end
end
