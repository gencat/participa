# frozen_string_literal: true

require "rails_helper"

# Extra filters (creation date and creator) in the participatory processes and
# assemblies admin lists.
describe "Admin space filters", type: :system, versioning: true do
  let!(:organization) { create(:organization) }
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }
  let!(:creator) { create(:user, :confirmed, organization:, name: "Ana Puig", nickname: "anapuig", email: "ana.puig@example.org") }
  let!(:other_user) { create(:user, :confirmed, organization:, name: "Joan Ribas", nickname: "jribas", email: "joan.ribas@example.org") }

  def create_space(title, whodunnit:, created_at:)
    PaperTrail.request(whodunnit: whodunnit.to_gid.to_s) do
      create(factory, organization:, title: { en: title }, created_at:)
    end
  end

  def toggle
    find("[data-space-filters-toggle]")
  end

  def submit_filters
    find(".filters__section button.button__secondary[type='submit']").click
  end

  shared_examples "space list with creation filters" do
    let!(:january_by_creator) { create_space("January by Ana", whodunnit: creator, created_at: Time.zone.local(2026, 1, 15, 10, 0)) }
    let!(:february_by_creator) { create_space("February by Ana", whodunnit: creator, created_at: Time.zone.local(2026, 2, 15, 10, 0)) }
    let!(:january_by_other) { create_space("January by Joan", whodunnit: other_user, created_at: Time.zone.local(2026, 1, 20, 10, 0)) }

    before do
      switch_to_host(organization.host)
      login_as admin, scope: :user
    end

    context "when no extra filter is applied" do
      before { visit list_path }

      it "hides the extra filters until the toggle is clicked" do
        expect(toggle["aria-expanded"]).to eq("false")
        expect(page).to have_no_field("q[creator_search]")

        toggle.click

        expect(toggle["aria-expanded"]).to eq("true")
        expect(page).to have_field("q[creator_search]")
        expect(page).to have_css("#q_created_at_from_date_date")
        expect(page).to have_css("#q_created_at_to_date_date")
        expect(page).to have_css(".filters__section button.button__secondary[type='submit']")

        toggle.click

        expect(toggle["aria-expanded"]).to eq("false")
        expect(page).to have_no_field("q[creator_search]")
      end

      it "shows only date fields, without time" do
        toggle.click

        expect(page).to have_no_css("#q_created_at_from_date_time")
        expect(page).to have_no_css("#q_created_at_to_date_time")
      end
    end

    context "when an extra filter is applied" do
      before { visit "#{list_path}?q[creator_search]=anapuig" }

      it "shows the extra filters opened with the applied value" do
        expect(toggle["aria-expanded"]).to eq("true")
        expect(page).to have_field("q[creator_search]", with: "anapuig")
      end
    end

    it "filters by creator" do
      visit list_path
      toggle.click
      fill_in "q[creator_search]", with: "ana.puig@example"
      submit_filters

      expect(page).to have_content("January by Ana")
      expect(page).to have_content("February by Ana")
      expect(page).to have_no_content("January by Joan")
    end

    it "filters by creation date" do
      visit list_path
      toggle.click
      fill_in_datepicker :q_created_at_from_date_date, with: "01/01/2026"
      fill_in_datepicker :q_created_at_to_date_date, with: "31/01/2026"
      submit_filters

      expect(page).to have_content("January by Ana")
      expect(page).to have_content("January by Joan")
      expect(page).to have_no_content("February by Ana")
      expect(page).to have_field("q_created_at_from_date_date", with: "01/01/2026")
    end

    it "combines the creator, the creation date and the title search" do
      visit list_path
      toggle.click
      fill_in "q[title_cont]", with: "January"
      fill_in "q[creator_search]", with: "anapuig"
      fill_in_datepicker :q_created_at_to_date_date, with: "31/01/2026"
      submit_filters

      expect(page).to have_content("January by Ana")
      expect(page).to have_no_content("February by Ana")
      expect(page).to have_no_content("January by Joan")
    end
  end

  context "with participatory processes" do
    let(:factory) { :participatory_process }
    let(:list_path) { "/admin/participatory_processes" }

    it_behaves_like "space list with creation filters"
  end

  context "with assemblies" do
    let(:factory) { :assembly }
    let(:list_path) { "/admin/assemblies" }

    it_behaves_like "space list with creation filters"
  end
end
