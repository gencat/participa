# frozen_string_literal: true

# This migration comes from decidim (originally 20201013071533)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddReportedContentToModerations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_moderations, :reported_content, :text
  end
end
