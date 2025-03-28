# frozen_string_literal: true

require "rails_helper"

describe "Processes ContentBlock at home page" do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  describe "with highlighted processes content block active" do
    let!(:process) { create(:participatory_process, :promoted, :active, slug: "process", organization:, skip_injection: true) }
    let!(:regulation) { create(:participatory_process, :promoted, :active, slug: "regulation", organization:, decidim_participatory_process_group_id: Rails.application.config.regulation) }

    before do
      create(:content_block, manifest_name: :highlighted_processes, organization:, scope_name: :homepage)
    end

    it "renders the process but not the regulation" do
      visit decidim.root_path(locale: I18n.locale)
      expect(page).to have_content(translated(process.title))
      expect(page).to have_no_content(translated(regulation.title))
    end
  end
end
