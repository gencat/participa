# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20201116111200)

class CreateDecidimSolutionsSolutions < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_solutions_solutions do |t|
      t.jsonb :title
      t.jsonb :description
      t.references :decidim_component, index: true, null: false
      t.references :decidim_problems_problem, index: { name: "decidim_challenges_problems_solutions" }, null: false
      t.jsonb :tags
      t.jsonb :indicators
      t.jsonb :beneficiaries
      t.jsonb :requirements
      t.jsonb :financing_type
      t.jsonb :objectives
      t.timestamp :published_at

      t.timestamps
    end
  end
end
