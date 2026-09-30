# frozen_string_literal: true

# This migration comes from decidim (originally 20180215104821)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class CreateDecidimAreaTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_area_types do |t|
      t.references :decidim_organization, foreign_key: true, index: true
      t.jsonb :name, null: false
      t.jsonb :plural, null: false
    end
  end
end
