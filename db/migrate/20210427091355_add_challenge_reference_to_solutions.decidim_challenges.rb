# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20210413112229)

class AddChallengeReferenceToSolutions < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_solutions_solutions, :decidim_challenges_challenge, index: { name: "decidim_challenges_solutions" }
  end
end
