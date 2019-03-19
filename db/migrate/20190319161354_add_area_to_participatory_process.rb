# frozen_string_literal: true

class AddAreaToParticipatoryProcess < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_participatory_processes, :decidim_area, index: true
  end
end
