# frozen_string_literal: true

# This migration comes from decidim_stratified_sortitions (originally 20260109105643)
class AllowNullValueInSubstrata < ActiveRecord::Migration[7.0]
  def change
    change_column_null :decidim_stratified_sortitions_substrata, :value, true
    change_column_default :decidim_stratified_sortitions_substrata, :value, nil
  end
end
