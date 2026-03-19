# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20251219120100)
class CreateSampleParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_stratified_sortitions_sample_participants do |t|
      t.references :decidim_stratified_sortition, null: false, foreign_key: { to_table: :decidim_stratified_sortitions_stratified_sortitions },
                                                  index: { name: "idx_sample_part_on_sortition_id" }
      t.references :decidim_stratified_sortitions_sample_import, foreign_key: { to_table: :decidim_stratified_sortitions_sample_imports },
                                                                 index: { name: "idx_sample_part_on_sample_import_id" }
      t.string :personal_data_1, null: false
      t.string :personal_data_2
      t.string :personal_data_3
      t.string :personal_data_4
      t.jsonb :column_values, default: []
      t.string :reference_code
      t.timestamps
    end
  end
end
