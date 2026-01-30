# frozen_string_literal: true

# This migration comes from decidim_challenges (originally 20260116075427)
class AddAuthorTypeToChallengesSurveys < ActiveRecord::Migration[6.1]
  class ChallengeSurvey < ApplicationRecord
    self.table_name = "decidim_challenges_surveys"
  end

  def up
    add_column :decidim_challenges_surveys, :decidim_author_type, :string

    reversible do |direction|
      direction.up do
        execute <<~SQL.squish
          UPDATE decidim_challenges_surveys
          SET decidim_author_type = 'Decidim::UserBaseEntity'
        SQL
      end
    end

    remove_index :decidim_challenges_surveys, name: "decidim_challenges_surveys_author_challenge_unique", if_exists: true

    add_index :decidim_challenges_surveys,
              [:decidim_author_id, :decidim_author_type, :decidim_challenge_id],
              unique: true,
              name: "decidim_challenges_surveys_author_challenge_unique"
    change_column_null :decidim_challenges_surveys, :decidim_author_id, false
    change_column_null :decidim_challenges_surveys, :decidim_author_type, false
  end

  def down
    remove_index :decidim_challenges_surveys, name: "decidim_challenges_surveys_author_challenge_unique", if_exists: true

    remove_column :decidim_challenges_surveys, :decidim_author_type

    add_index :decidim_challenges_surveys,
              [:decidim_author_id, :decidim_challenge_id],
              unique: true,
              name: "decidim_challenges_surveys_author_challenge_unique"
  end
end
