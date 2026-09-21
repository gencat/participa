# frozen_string_literal: true

# This migration comes from decidim (originally 20220118121921)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class ChangeRequiredDescriptionCategories < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decidim_categories, :description, true
  end
end
