# frozen_string_literal: true

require "rails_helper"

describe "Children assemblies content block list mode", type: :system do
  let!(:organization) { create(:organization) }
  let!(:assembly) { create(:assembly, :published, organization:) }
  let!(:children) { create_list(:assembly, 3, :published, organization:, parent: assembly) }
  let(:list_mode) { true }
  let(:max_results) { 6 }

  before do
    create(:content_block, organization:, scope_name: :assembly_homepage, manifest_name: :related_assemblies,
                           scoped_resource_id: assembly.id, settings: { "max_results" => max_results, "list_mode" => list_mode })
    switch_to_host(organization.host)
  end

  def visit_assembly
    visit decidim_assemblies.assembly_path(assembly, locale: I18n.locale)
  end

  context "when list mode is enabled" do
    it "renders the children assemblies as a list of search cards" do
      visit_assembly

      within ".children-assemblies__list" do
        expect(page).to have_css("div.card__search", count: 3)
        children.each do |child|
          expect(page).to have_css("a[href*='#{decidim_assemblies.assembly_path(child)}']")
        end
      end
      expect(page).to have_no_css(".participatory-space__block-grid")
    end

    context "when a child has its own published children" do
      before { create(:assembly, :published, organization:, parent: children.first) }

      it "shows the children count metadata in its card" do
        visit_assembly

        within "##{ActionView::RecordIdentifier.dom_id(children.first)}" do
          expect(page).to have_css(".card__search-metadata")
          expect(page).to have_content(I18n.t("layouts.decidim.assemblies.metadata.children_item", count: 1))
        end
      end
    end

    context "when there are more children than max_results" do
      let(:max_results) { 2 }

      it "limits the cards but keeps the total count in the header" do
        visit_assembly

        expect(page).to have_css(".children-assemblies__list div.card__search", count: 2)
        expect(page).to have_css(".content-block__title .label", text: "3")
      end
    end

    context "when there are no children" do
      let!(:children) { [] }

      it "does not render the content block" do
        visit_assembly

        expect(page).to have_no_css(".children-assemblies__list")
      end
    end
  end

  context "when list mode is disabled" do
    let(:list_mode) { false }

    it "renders the children assemblies in the default grid" do
      visit_assembly

      expect(page).to have_css(".participatory-space__block-grid a.card__grid", count: 3)
      expect(page).to have_no_css(".children-assemblies__list")
    end
  end
end
