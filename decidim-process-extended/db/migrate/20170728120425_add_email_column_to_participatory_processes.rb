# frozen_string_literal: true

class AddEmailColumnToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :email, :string
  end
end
