# frozen_string_literal: true

# This migration comes from decidim (originally 20220203121137)
# This file has been modified by `decidim upgrade:migrations` task on 2026-05-05 09:26:03 UTC
class AddNotificationsSendingFrequencyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_users, :notifications_sending_frequency, :string, default: "daily", index: true
  end
end
