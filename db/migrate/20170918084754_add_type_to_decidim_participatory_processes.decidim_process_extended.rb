# frozen_string_literal: true

# This migration comes from decidim_process_extended (originally 20170829072136)
class AddTypeToDecidimParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :decidim_type_id, :integer
  end
end
