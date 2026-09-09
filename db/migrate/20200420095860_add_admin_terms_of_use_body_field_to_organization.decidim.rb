# frozen_string_literal: true

# This migration comes from decidim (originally 20191118123154)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddAdminTermsOfUseBodyFieldToOrganization < ActiveRecord::Migration[5.2]
  def change
    change_table :decidim_organizations do |t|
      t.jsonb :admin_terms_of_use_body, null: true
    end
  end
end
