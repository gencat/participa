# frozen_string_literal: true

# This migration comes from decidim_process_extended (originally 20170719125954)

class AddThemeColumnToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :theme_id, :integer
  end
end
