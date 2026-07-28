# frozen_string_literal: true

# This migration comes from decidim_challenges (originally 20260526153523)
class RemoveScopeFromChallengesAndProblems < ActiveRecord::Migration[7.0]
  def change
    remove_column :decidim_challenges_challenges, :decidim_scope_id, :bigint
    remove_column :decidim_problems_problems, :decidim_sectorial_scope_id, :bigint
    remove_column :decidim_problems_problems, :decidim_technological_scope_id, :bigint
  end
end
