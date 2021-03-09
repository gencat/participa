# frozen_string_literal: true

class ChangeNameFormatInDecidimTypes < ActiveRecord::Migration[5.1]
  def up
    change_column :decidim_types, :name, "jsonb USING CAST(name AS jsonb)"
  end

  def down
    change_column :decidim_types, :name, :string
  end
end
