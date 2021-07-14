# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20210413083244)

class CreateDecidimChallengesSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_challenges_surveys do |t|
      t.references :decidim_user, null: false, index: true
      t.references :decidim_challenge, null: false, index: true

      t.timestamps
    end

    add_index :decidim_challenges_surveys, [:decidim_user_id, :decidim_challenge_id], unique: true, name: "decidim_challenges_surveys_user_challenge_unique"
  end
end
