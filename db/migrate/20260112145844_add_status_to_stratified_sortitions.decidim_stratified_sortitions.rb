# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260102114744)
class AddStatusToStratifiedSortitions < ActiveRecord::Migration[7.0]
  def up
    add_column :decidim_stratified_sortitions_stratified_sortitions, :status, :string, default: "pending"
  end

  def down
    remove_column :decidim_stratified_sortitions_stratified_sortitions, :status
  end
end
