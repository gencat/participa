# frozen_string_literal: true

require "rails_helper"

describe "Redirect Middleware", type: :system do
  let!(:organization) { process.organization }
  let!(:process) { create(:participatory_process, slug: slug, title: { ca: title_ca }) }

  before do
    switch_to_host(organization.host)
  end

  describe "Futur Europa redirect" do
    let(:title_ca) { "El futur d'Europa" }
    let(:slug) { "FuturEuropa" }

    it "redirects to the process when /futur-europa is visited" do
      visit "/futur-europa"
      expect(page).to have_content(title_ca)
    end
  end

  describe "Pla director cooperació" do
    let(:title_ca) { "Pla director cooperació" }
    let(:slug) { "pladirectorcooperacio" }

    it "redirects to the process when /participacooperacio is visited" do
      visit "/participacooperacio"
      expect(page).to have_content(title_ca)
    end
  end

  describe "Assemblea clima" do
    let(:title_ca) { "Assemblea clima" }
    let(:slug) { "assembleaclima" }

    it "redirects to the process when /assembleaclima is visited" do
      visit "/assembleaclima"
      expect(page).to have_content(title_ca)
    end
  end

  describe "Assemblea clima inscripcions" do
    let(:title_ca) { "Assemblea clima inscripcions" }
    let(:slug) { "assembleaclima" }
    let!(:component) do
      create :component,
             id: 3825,
             manifest_name: :meetings,
             published_at: Time.zone.now,
             participatory_space: process
    end

    it "redirects to registrations when /assembleaclima/inscripcions is visited" do
      visit "/assembleaclima/inscripcions"

      expect(page).to have_current_path("/processes/assembleaclima/f/3825/meetings")
    end
  end
end
