# frozen_string_literal: true

# This migration comes from decidim_type (originally 20170828112938)
class CreateDecidimTypeDecidimTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_types do |t|
      t.string :name
      t.references :decidim_organization, foreign_key: true, index: true

      t.timestamps
    end
  end
end
