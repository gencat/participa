# frozen_string_literal: true

class AddGoogleMapsUrlToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_meetings_meetings, :google_maps_url, :string
  end
end
