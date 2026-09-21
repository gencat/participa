# frozen_string_literal: true

require "rails_helper"

describe "Google Maps URL on meeting show page", type: :system do
  let!(:organization) { create(:organization) }
  let!(:participatory_process) { create(:participatory_process, :published, :with_steps, organization:) }
  let!(:meetings_component) { create(:meeting_component, :published, participatory_space: participatory_process) }
  let(:google_maps_url) { "https://www.google.com/maps/place/Test+Location" }

  before do
    switch_to_host(organization.host)
    stub_request(:get, %r{nominatim\.openstreetmap\.org/reverse}).to_return(status: 200, body: "{}", headers: { "Content-Type" => "application/json" })
  end

  def meeting_show_path(meeting)
    "/processes/#{participatory_process.slug}/f/#{meetings_component.id}/meetings/#{meeting.id}"
  end

  context "when the meeting is in_person and has a google_maps_url" do
    let!(:meeting) do
      create(:meeting, :published, :in_person, component: meetings_component, google_maps_url:)
    end

    before { visit meeting_show_path(meeting) }

    it "renders the address as a clickable Google Maps link" do
      expect(page).to have_css(".address__address a[href='#{google_maps_url}'][target='_blank']")
    end
  end

  context "when the meeting is hybrid and has a google_maps_url" do
    let!(:meeting) do
      create(:meeting, :published, :hybrid, component: meetings_component, google_maps_url:)
    end

    before { visit meeting_show_path(meeting) }

    it "renders the address as a clickable Google Maps link" do
      expect(page).to have_css(".address__address a[href='#{google_maps_url}'][target='_blank']")
    end
  end

  context "when the meeting is in_person but has no google_maps_url" do
    let!(:meeting) do
      create(:meeting, :published, :in_person, component: meetings_component, google_maps_url: nil)
    end

    before { visit meeting_show_path(meeting) }

    it "renders the address as plain text without a link" do
      expect(page).to have_css(".address__address")
      expect(page).to have_no_css(".address__address a")
    end
  end
end
