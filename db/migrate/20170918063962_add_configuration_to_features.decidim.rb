# frozen_string_literal: true

# This migration comes from decidim (originally 20170110133113)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddConfigurationToFeatures < ActiveRecord::Migration[5.0]
  def change
    change_table :decidim_features do |t|
      t.jsonb :settings, default: {}
    end
  end
end
