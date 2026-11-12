# frozen_string_literal: true

require "rails_helper"

describe Decidim::AddressCellDecorator do
  subject { Decidim::AddressCell.new(meeting).send(:address) }

  let(:google_maps_url) { "https://www.google.com/maps/place/test+location" }
  let(:meeting) { create(:meeting, :published, :in_person, address:, google_maps_url:) }

  context "when the meeting has an address and a Google Maps URL" do
    let(:address) { "Carrer Major, 1" }

    it "links the address to Google Maps" do
      expect(subject).to include("href=\"#{google_maps_url}\"")
      expect(subject).to include(address)
    end
  end

  context "when the meeting has a Google Maps URL but no address" do
    let(:address) { "" }

    it "does not render an empty link" do
      expect(subject.to_s).not_to include("<a")
    end
  end

  context "when the meeting has an address but no Google Maps URL" do
    let(:address) { "Carrer Major, 1" }
    let(:google_maps_url) { nil }

    it "renders the address as plain text" do
      expect(subject.to_s).not_to include("<a")
      expect(subject).to include(address)
    end
  end
end
