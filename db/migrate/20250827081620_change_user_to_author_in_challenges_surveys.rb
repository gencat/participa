class ChangeUserToAuthorInChallengesSurveys < ActiveRecord::Migration[6.1]
  class ChallengeSurvey < ApplicationRecord
    self.table_name = "decidim_challenges_surveys"
  end

  def up
    rename_column :decidim_challenges_surveys, :decidim_user_id, :decidim_author_id
    add_column :decidim_challenges_surveys, :decidim_author_type, :string

    ChallengeSurvey.update_all(decidim_author_type: "Decidim::UserBaseEntity")

    change_column_null :decidim_challenges_surveys, :decidim_author_type, false

    remove_index :decidim_challenges_surveys, name: "decidim_challenges_surveys_user_challenge_unique", if_exists: true
    remove_index :decidim_challenges_surveys, name: "index_decidim_challenges_surveys_on_decidim_user_id", if_exists: true

    add_index :decidim_challenges_surveys,
              [:decidim_author_id, :decidim_author_type],
              name: "decidim_challenges_surveys_author"

    add_index :decidim_challenges_surveys,
              [:decidim_author_id, :decidim_challenge_id],
              unique: true,
              name: "decidim_challenges_surveys_author_challenge_unique"
  end

  def down
    remove_index :decidim_challenges_surveys, name: "decidim_challenges_surveys_author", if_exists: true
    remove_index :decidim_challenges_surveys, name: "decidim_challenges_surveys_author_challenge_unique", if_exists: true

    remove_column :decidim_challenges_surveys, :decidim_author_type
    rename_column :decidim_challenges_surveys, :decidim_author_id, :decidim_user_id

    add_index :decidim_challenges_surveys,
              [:decidim_user_id, :decidim_challenge_id],
              unique: true,
              name: "decidim_challenges_surveys_user_challenge_unique"

    add_index :decidim_challenges_surveys,
              :decidim_user_id,
              name: "index_decidim_challenges_surveys_on_decidim_user_id"
  end
end
