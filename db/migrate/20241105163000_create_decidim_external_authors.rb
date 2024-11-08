# frozen_string_literal: true
# This migration comes from decidim (originally 20220629194812)

class CreateDecidimExternalAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_external_authors do |t|
      t.string      :name, null: false
      t.references  :decidim_organization, index: true, foreign_key: true

      t.timestamps
    end

    add_index :decidim_external_authors, :name, unique: true
  end
end
