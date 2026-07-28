# frozen_string_literal: true

# This migration comes from decidim (originally 20161010131544)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddLocaleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_users, :locale, :string
  end
end
