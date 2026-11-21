# frozen_string_literal: true

# This migration comes from decidim_process_extended (originally 20261028090000)
class AddSocialHandlersToParticipatoryProcesses < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_participatory_processes, :twitter_handler, :string
    add_column :decidim_participatory_processes, :facebook_handler, :string
    add_column :decidim_participatory_processes, :instagram_handler, :string
    add_column :decidim_participatory_processes, :youtube_handler, :string
    add_column :decidim_participatory_processes, :github_handler, :string
  end
end
