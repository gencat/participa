# frozen_string_literal: true

require "rails_helper"

describe "Admin Google Maps URL field for meetings", type: :system do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:participatory_process) { create(:participatory_process, :published, :with_steps, organization:) }
  let!(:meetings_component) { create(:meeting_component, :published, participatory_space: participatory_process) }
  let(:google_maps_url) { "https://www.google.com/maps/place/test+location" }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  def admin_edit_meeting_path(meeting)
    "/admin/participatory_processes/#{participatory_process.slug}/components/#{meetings_component.id}/manage/meetings/#{meeting.id}/edit"
  end

  context "when editing an in_person meeting" do
    let!(:meeting) { create(:meeting, :published, :in_person, component: meetings_component) }

    before { visit admin_edit_meeting_path(meeting) }

    it "shows the google_maps_url field" do
      expect(page).to have_css("input[name='meeting[google_maps_url]']", visible: :visible)
    end

    it "saves a valid google_maps_url" do
      fill_in "meeting[google_maps_url]", with: google_maps_url
      find("button[name='commit']").click
      expect(page).to have_admin_callout("successfully")
      expect(meeting.reload.google_maps_url).to eq(google_maps_url)
    end

    it "shows a validation error for an invalid URL" do
      fill_in "meeting[google_maps_url]", with: "not-a-url"
      find("button[name='commit']").click
      expect(page).to have_admin_callout("problem updating this meeting")
    end

    it "shows a validation error for a URL not from Google Maps" do
      fill_in "meeting[google_maps_url]", with: "https://example.com/maps/place/test"
      find("button[name='commit']").click
      expect(page).to have_admin_callout("problem updating this meeting")
    end

    it "allows saving with a blank google_maps_url" do
      fill_in "meeting[google_maps_url]", with: ""
      find("button[name='commit']").click
      expect(page).to have_admin_callout("successfully")
      expect(meeting.reload.google_maps_url).to be_blank
    end
  end

  context "when editing an online meeting" do
    let!(:meeting) { create(:meeting, :published, :online, component: meetings_component) }

    before { visit admin_edit_meeting_path(meeting) }

    it "does not show the google_maps_url field" do
      expect(page).to have_css("input[name='meeting[google_maps_url]']", visible: :hidden)
    end
  end

  context "when editing a hybrid meeting" do
    let!(:meeting) { create(:meeting, :published, :hybrid, component: meetings_component) }

    before { visit admin_edit_meeting_path(meeting) }

    it "shows the google_maps_url field" do
      expect(page).to have_css("input[name='meeting[google_maps_url]']", visible: :visible)
    end

    it "saves a valid google_maps_url for a hybrid meeting" do
      fill_in "meeting[google_maps_url]", with: google_maps_url
      find("button[name='commit']").click
      expect(page).to have_admin_callout("successfully")
      expect(meeting.reload.google_maps_url).to eq(google_maps_url)
    end
  end
end
