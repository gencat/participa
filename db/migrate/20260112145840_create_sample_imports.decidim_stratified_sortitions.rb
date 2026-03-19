# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20251219120000)
class CreateSampleImports < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_stratified_sortitions_sample_imports do |t|
      t.references :stratified_sortition, null: false, foreign_key: { to_table: :decidim_stratified_sortitions_stratified_sortitions },
                                          index: { name: "idx_sample_imports_on_sortition_id" }
      t.string :filename
      t.integer :total_rows, default: 0
      t.integer :imported_rows, default: 0
      t.integer :failed_rows, default: 0
      t.jsonb :import_errors, default: {}
      t.string :status, default: "pending"
      t.timestamps
    end
  end
end
