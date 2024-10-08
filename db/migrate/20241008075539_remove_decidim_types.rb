class RemoveDecidimTypes < ActiveRecord::Migration[6.1]
  def change
    drop_table :decidim_types
  end
end
