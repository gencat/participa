# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20201103155100)

class CreateDecidimProblemsProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_problems_problems do |t|
      t.jsonb :title
      t.jsonb :description
      t.references :decidim_component, index: true, null: false
      t.references :decidim_challenges_challenge, index: { name: "decidim_challenges_challenges_problems" }, null: false
      t.bigint "decidim_sectorial_scope_id"
      t.bigint "decidim_technological_scope_id"
      t.jsonb :tags
      t.string :causes
      t.string :groups_affected
      t.integer :state, null: false, default: 0
      t.date :start_date
      t.date :end_date
      t.timestamp :published_at
      t.string :proposing_entities
      t.string :collaborating_entities

      t.timestamps
    end
  end
end
