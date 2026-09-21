# frozen_string_literal: true

# This migration comes from decidim (originally 20180705091019)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class CreateDecidimResourcePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_resource_permissions do |t|
      t.belongs_to :resource, polymorphic: true, index: { name: "index_decidim_resource_permissions_on_r_type_and_r_id", unique: true }
      t.jsonb :permissions, default: {}

      t.timestamps
    end
  end
end
