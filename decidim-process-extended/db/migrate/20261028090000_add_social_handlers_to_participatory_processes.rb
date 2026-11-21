# frozen_string_literal: true

class AddSocialHandlersToParticipatoryProcesses < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_participatory_processes, :twitter_handler, :string
    add_column :decidim_participatory_processes, :facebook_handler, :string
    add_column :decidim_participatory_processes, :instagram_handler, :string
    add_column :decidim_participatory_processes, :youtube_handler, :string
    add_column :decidim_participatory_processes, :github_handler, :string
  end
end
