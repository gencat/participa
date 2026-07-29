# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260616000000)
class AddExecutionErrorToStratifiedSortitions < ActiveRecord::Migration[7.0]
  def up
    add_column :decidim_stratified_sortitions_stratified_sortitions, :execution_error, :text
  end

  def down
    remove_column :decidim_stratified_sortitions_stratified_sortitions, :execution_error
  end
end
