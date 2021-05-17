# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20210427091033)

class RemoveRequireNullInProblemsForSolutions < ActiveRecord::Migration[5.2]
  def change
    change_column_null :decidim_solutions_solutions, :decidim_problems_problem_id, true
  end
end
