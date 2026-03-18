# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20251023103900)
class CreateDecidimStratifiedSortitionsStratifiedSortitions < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_stratified_sortitions_stratified_sortitions do |t|
      t.jsonb :title
      t.integer :num_candidates, null: false
      t.jsonb :description
      t.jsonb :selection_criteria
      t.jsonb :selected_profiles_description
      t.references :decidim_component, index: false, null: false

      t.timestamps
    end

    add_index :decidim_stratified_sortitions_stratified_sortitions, :decidim_component_id, name: "index_decidim_stratified_sortitions_component_id"
  end
end
