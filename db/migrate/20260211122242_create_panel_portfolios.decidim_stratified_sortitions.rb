# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260127120000)
# Migration to create the panel_portfolios table for storing
# LEXIMIN-generated panels before sampling.
#
# This enables a two-phase sortition process:
# 1. Generate portfolio (expensive, can be done in background)
# 2. Sample from portfolio (fast, can be done publicly)
class CreatePanelPortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_stratified_sortitions_panel_portfolios do |t|
      t.references :decidim_stratified_sortitions_stratified_sortition,
                   null: false,
                   foreign_key: { to_table: :decidim_stratified_sortitions_stratified_sortitions },
                   index: { name: "idx_panel_portfolios_on_sortition_id" }

      # Panel data (JSON arrays)
      # panels: [[id1, id2, ...], [id3, id4, ...], ...]
      # probabilities: [0.3, 0.25, ...]
      # selection_probabilities: { participant_id => probability, ... }
      t.jsonb :panels, null: false, default: []
      t.jsonb :probabilities, null: false, default: []
      t.jsonb :selection_probabilities, null: false, default: {}

      # Generation metadata
      t.datetime :generated_at, null: false
      t.float :generation_time_seconds
      t.integer :num_iterations
      t.boolean :convergence_achieved, null: false, default: false

      # Sampling result (null until sampled)
      t.integer :selected_panel_index
      t.datetime :selected_at
      t.string :verification_seed
      t.float :random_value_used

      t.timestamps
    end

    # Ensure only one portfolio per sortition
    add_index :decidim_stratified_sortitions_panel_portfolios,
              :decidim_stratified_sortitions_stratified_sortition_id,
              unique: true,
              name: "idx_panel_portfolios_unique_sortition"
  end
end
