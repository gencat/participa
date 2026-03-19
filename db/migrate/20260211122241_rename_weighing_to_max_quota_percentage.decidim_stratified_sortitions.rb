# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260127100000)
# This migration renames the 'weighing' column to 'max_quota_percentage' for clarity.
# The column stores the target percentage for each substratum category.
# For the LEXIMIN algorithm:
#   - min_quota is implicitly 0 (no minimum required for any category)
#   - max_quota is calculated as: (max_quota_percentage / 100.0) * panel_size
class RenameWeighingToMaxQuotaPercentage < ActiveRecord::Migration[7.0]
  def change
    rename_column :decidim_stratified_sortitions_substrata, :weighing, :max_quota_percentage
  end
end
