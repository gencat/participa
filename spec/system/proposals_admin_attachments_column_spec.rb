# frozen_string_literal: true

require "rails_helper"

describe "Admin proposals attachments column", type: :system do
  let(:manifest_name) { "proposals" }

  include_context "when managing a component as an admin"

  let!(:proposal) { create(:proposal, component:, users: [user]) }

  context "when the component has attachments allowed" do
    let!(:component) do
      create(:component,
             manifest_name: :proposals,
             participatory_space: participatory_process,
             settings: { "attachments_allowed" => true })
    end

    before { visit_component_admin }

    it "shows the attachments column header" do
      expect(page).to have_css("thead th", text: I18n.t("decidim.proposals.models.proposal.fields.attachments"))
    end

    it "shows the attachment count for each proposal row" do
      within("tbody tr", match: :first) do
        expect(page).to have_content(proposal.attachments.size.to_s)
      end
    end
  end

  context "when the component does not have attachments allowed" do
    before { visit_component_admin }

    it "does not show the attachments column header" do
      expect(page).not_to have_css("thead th", text: I18n.t("decidim.proposals.models.proposal.fields.attachments"))
    end
  end
end
