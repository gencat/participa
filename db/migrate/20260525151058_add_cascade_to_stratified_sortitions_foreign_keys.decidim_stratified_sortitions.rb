# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260521000000)
class AddCascadeToStratifiedSortitionsForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :decidim_stratified_sortitions_strata,
                    :decidim_stratified_sortitions_stratified_sortitions,
                    column: :decidim_stratified_sortition_id,
                    on_delete: :cascade

    add_foreign_key :decidim_stratified_sortitions_substrata,
                    :decidim_stratified_sortitions_strata,
                    column: :decidim_stratified_sortitions_stratum_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_imports,
                       column: :stratified_sortition_id
    add_foreign_key :decidim_stratified_sortitions_sample_imports,
                    :decidim_stratified_sortitions_stratified_sortitions,
                    column: :stratified_sortition_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_participants,
                       column: :decidim_stratified_sortition_id
    add_foreign_key :decidim_stratified_sortitions_sample_participants,
                    :decidim_stratified_sortitions_stratified_sortitions,
                    column: :decidim_stratified_sortition_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_participants,
                       column: :decidim_stratified_sortitions_sample_import_id
    add_foreign_key :decidim_stratified_sortitions_sample_participants,
                    :decidim_stratified_sortitions_sample_imports,
                    column: :decidim_stratified_sortitions_sample_import_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                       column: :decidim_stratified_sortitions_sample_participant_id
    add_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                    :decidim_stratified_sortitions_sample_participants,
                    column: :decidim_stratified_sortitions_sample_participant_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                       column: :decidim_stratified_sortitions_stratum_id
    add_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                    :decidim_stratified_sortitions_strata,
                    column: :decidim_stratified_sortitions_stratum_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                       column: :decidim_stratified_sortitions_substratum_id
    add_foreign_key :decidim_stratified_sortitions_sample_participant_strata,
                    :decidim_stratified_sortitions_substrata,
                    column: :decidim_stratified_sortitions_substratum_id,
                    on_delete: :cascade

    remove_foreign_key :decidim_stratified_sortitions_panel_portfolios,
                       column: :decidim_stratified_sortitions_stratified_sortition_id
    add_foreign_key :decidim_stratified_sortitions_panel_portfolios,
                    :decidim_stratified_sortitions_stratified_sortitions,
                    column: :decidim_stratified_sortitions_stratified_sortition_id,
                    on_delete: :cascade
  end
end
