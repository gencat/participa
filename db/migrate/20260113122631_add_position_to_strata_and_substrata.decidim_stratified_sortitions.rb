# This migration comes from decidim_stratified_sortitions (originally 20260113121726)
class AddPositionToStrataAndSubstrata < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_stratified_sortitions_substrata, :position, :integer
    add_column :decidim_stratified_sortitions_strata, :position, :integer
  end
end
