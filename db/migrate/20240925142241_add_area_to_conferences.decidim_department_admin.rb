# frozen_string_literal: true
# This migration comes from decidim_department_admin (originally 20210420143021)

class AddAreaToConferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_conferences, :decidim_area, index: true if Decidim::DepartmentAdmin.conferences_defined?
  end
end
