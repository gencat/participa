# frozen_string_literal: true

class CreateDecidimTypeDecidimTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_types do |t|
      t.string :name
      t.references :decidim_organization, foreign_key: true, index: true

      t.timestamps
    end
  end
end
