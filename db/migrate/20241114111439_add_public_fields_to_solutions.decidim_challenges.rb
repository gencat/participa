# frozen_string_literal: true
# This migration comes from decidim_challenges (originally 20240919094714)

class AddPublicFieldsToSolutions < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_solutions_solutions, :project_status, :string
    add_column :decidim_solutions_solutions, :project_url, :string
    add_column :decidim_solutions_solutions, :coordinating_entity, :string
    add_reference :decidim_solutions_solutions, :author, foreign_key: { to_table: :decidim_users }, index: true
  end
end
