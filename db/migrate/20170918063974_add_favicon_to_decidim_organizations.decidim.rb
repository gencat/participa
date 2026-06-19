# frozen_string_literal: true

# This migration comes from decidim (originally 20170130132833)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddFaviconToDecidimOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_organizations, :favicon, :string
  end
end
