# frozen_string_literal: true

# This migration comes from decidim_blogs (originally 20191212162606)

class DeleteFederFromContentBlocks < ActiveRecord::Migration[5.2]
  class ContentBlock < ApplicationRecord
    self.table_name = :decidim_content_blocks
  end

  def up
    feder = ContentBlock.find_by(manifest_name: "feder")
    feder.delete unless feder.nil?
  end

  def down
    ContentBlock.create decidim_organitzation_id: 1, manifest_name: "feder", scope: "homepage", settings: nil, published_at: "2019-04-04 05:44:11.276", weight: 11, images: "{}"
  end
end
