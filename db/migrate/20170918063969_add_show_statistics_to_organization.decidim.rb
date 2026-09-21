# frozen_string_literal: true

# This migration comes from decidim (originally 20170119150649)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddShowStatisticsToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_organizations, :show_statistics, :boolean, default: true
  end
end
