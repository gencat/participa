# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20251104120000)
class CreateDecidimStratifiedSortitionsStrataAndSubstrata < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_stratified_sortitions_strata do |t|
      t.jsonb :name, null: false, default: '{}'
      t.string :kind, null: false
      t.integer :decidim_stratified_sortition_id, null: false

      t.timestamps
    end

    add_index :decidim_stratified_sortitions_strata, :decidim_stratified_sortition_id, name: "index_strata_on_sortition_id"

    create_table :decidim_stratified_sortitions_substrata do |t|
      t.jsonb :name, null: false, default: '{}'
      t.jsonb :value, null: false, default: '{}'
      t.string :range
      t.string :weighing
      t.integer :decidim_stratified_sortitions_stratum_id, null: false

      t.timestamps
    end

    add_index :decidim_stratified_sortitions_substrata, :decidim_stratified_sortitions_stratum_id, name: "index_substrata_on_stratum_id"
  end
end
