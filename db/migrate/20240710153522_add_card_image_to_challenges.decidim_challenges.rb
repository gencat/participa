# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20220407110503)

class AddCardImageToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_challenges_challenges, :card_image, :string
  end
end
