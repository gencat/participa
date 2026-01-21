# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20251219120200)
class CreateSampleParticipantStrata < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_stratified_sortitions_sample_participant_strata do |t|
      t.references :decidim_stratified_sortitions_sample_participant, null: false, foreign_key: true, index: { name: "idx_sample_part_strata_on_participants" }
      t.references :decidim_stratified_sortitions_stratum, null: false, foreign_key: true, index: { name: "idx_sample_part_strata_on_strata" }
      t.references :decidim_stratified_sortitions_substratum,
                   null: true,
                   foreign_key: { to_table: :decidim_stratified_sortitions_substrata },
                   index: { name: "idx_sample_part_strata_on_substrata" }
      t.string :raw_value
      t.timestamps
    end
  end
end
