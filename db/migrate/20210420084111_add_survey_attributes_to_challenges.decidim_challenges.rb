# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20210413083507)

class AddSurveyAttributesToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_challenges_challenges, :survey_enabled, :boolean, null: false, default: false
  end
end
