# frozen_string_literal: true
# This migration comes from decidim (originally 20220629194812)

class CreateDecidimExternalAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_external_authors do |t|
      t.string   :name, null: false
      t.integer  :decidim_organization_id, index: true, foreign_key: true

      t.timestamps

      t.index [:decidim_organization_id, :name],
              name: "index_unique_name_and_organization",
              unique: true
    end

    add_index :decidim_external_authors, :name, unique: true
  end
end
