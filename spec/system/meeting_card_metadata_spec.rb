# frozen_string_literal: true

require "rails_helper"

describe "Meeting card metadata", type: :system do
  let!(:organization) { create(:organization) }
  let!(:participatory_process) { create(:participatory_process, :published, organization:, title: { "en" => "Test participatory process", "es" => "Test proceso participativo" }) }
  let!(:meetings_component) { create(:meeting_component, :published, participatory_space: participatory_process) }
  let!(:meeting) { create(:meeting, :published, component: meetings_component, title: { "en" => "Test Meeting", "es" => "Test reunion" }) }

  before do
    switch_to_host(organization.host)
  end

  context "when viewing general meetings page (/meetings)" do
    before do
      visit decidim.meetings_path
    end

    it "shows participatory process name for each meeting card" do
      expect(page).to have_content("Test participatory process")

      within("[data-meeting-id='#{meeting.id}']") do
        expect(page).to have_content("Test participatory process")
      end
    end
  end

  context "when viewing meetings within a specific participatory process" do
    before do
      visit decidim_participatory_processes.participatory_process_meetings_path(participatory_process)
    end

    it "does not show participatory process name for meetings from the same process" do
      expect(page).to have_content("Test participatory process")

      within("[data-meeting-id='#{meeting.id}']") do
        expect(page).to have_no_content("Test participatory process")
      end
    end
  end
end
