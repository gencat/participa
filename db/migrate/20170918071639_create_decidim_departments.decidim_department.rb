# frozen_string_literal: true

# This migration comes from decidim_department (originally 20170824094746)
class CreateDecidimDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_departments do |t|
      t.string :name
      t.references :decidim_organization, foreign_key: true, index: true

      t.timestamps
    end
  end
end
