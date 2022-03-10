# frozen_string_literal: true

# This migration comes from decidim_process_extended (originally 20170728120425)

class AddEmailColumnToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :email, :string
  end
end
