# frozen_string_literal: true

require "rails_helper"

describe "Admin proposals attachments column", type: :system do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:participatory_process) { create(:participatory_process, :published, organization:) }
  let!(:proposal) { create(:proposal, component:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit "/admin/participatory_processes/#{participatory_process.slug}/components/#{component.id}/manage/"
  end

  def header_cells
    all("table thead th")
  end

  def proposal_cells
    all("tr[data-id='#{proposal.id}'] td")
  end

  context "when attachments are allowed" do
    let!(:component) { create(:proposal_component, :published, :with_attachments_allowed, participatory_space: participatory_process) }
    let!(:proposal) do
      create(:proposal, component:).tap { |proposal| create_list(:attachment, 2, attached_to: proposal) }
    end

    it "shows the attachments header after the evaluators one" do
      evaluators_index = header_cells.index { |th| th.has_css?("a[href*='evaluation_assignments_count']") }

      expect(header_cells[evaluators_index + 1]).to have_css("a[href*='attachments_count']")
    end

    it "shows the number of attachments after the evaluators cell" do
      cell = find("tr[data-id='#{proposal.id}'] td.evaluators-count + td")

      expect(cell).to have_text("2")
      expect(cell["data-label"]).to eq(I18n.t("models.proposal.fields.attachments", scope: "decidim.proposals"))
    end

    it "keeps the same number of headers and cells" do
      expect(proposal_cells.size).to eq(header_cells.size)
    end
  end

  context "when attachments are not allowed" do
    let!(:component) { create(:proposal_component, :published, participatory_space: participatory_process) }

    it "does not show the attachments column" do
      expect(page).to have_no_css("table thead th a[href*='attachments_count']")
      expect(proposal_cells.size).to eq(header_cells.size)
    end
  end
end
