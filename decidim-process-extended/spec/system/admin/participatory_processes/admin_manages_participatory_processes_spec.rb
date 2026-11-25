# frozen_string_literal: true

require "spec_helper"

describe "Admin manages participatory processes", type: :system do
  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }

  let!(:participatory_process_group) { nil }
  let!(:participatory_process) { create(:participatory_process, organization:, decidim_participatory_process_group_id: participatory_process_group&.id) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "when there is no process group" do
    context "and there is a published proposal component" do
      let!(:proposal_component) do
        create(:component, manifest_name: "proposals", participatory_space: participatory_process, published_at: Time.current)
      end

      it "don't show the proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_on translated(participatory_process.title)
        expect(page).to have_no_css(".alert")
        expect(page).to have_no_text("Recordeu que heu d'activar el component propostes.")
      end
    end
  end

  describe "when participatory process group is 'Normativa'" do
    let!(:participatory_process_group) do
      create(:participatory_process_group, organization:,
                                           title: { en: "Normativa", es: "Normativa", ca: "Normativa" })
    end

    context "and there is not a proposal component" do
      it "don't show the proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_on translated(participatory_process.title)
        expect(page).to have_no_css(".alert")
        expect(page).to have_no_text("Recordeu que heu d'activar el component propostes.")
      end
    end

    context "and there is an unpublished proposal component" do
      let!(:proposal_component) do
        create(:component, :unpublished, manifest_name: "proposals", participatory_space: participatory_process)
      end

      it "show proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_on translated(participatory_process.title)
        expect(page).to have_css(".callout.alert", text: I18n.t("decidim.participatory_processes.admin.participatory_processes.proposal_component_alert"))
      end
    end

    context "and there is a published proposal component" do
      let!(:proposal_component) do
        create(:component, manifest_name: "proposals", participatory_space: participatory_process, published_at: Time.current)
      end

      it "don't show the proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_on translated(participatory_process.title)
        expect(page).to have_no_css(".alert")
        expect(page).to have_no_text("Recordeu que heu d'activar el component propostes.")
      end
    end
  end

  describe "editing a participatory process" do
    let!(:participatory_process) do
      create(:participatory_process, organization:, cost: 1500.5, email: "bustia@example.org", has_summary_record: true,
                                     promoting_unit: "Unitat promotora", facilitators: "Entitats dinamitzadores")
    end

    before do
      visit decidim_admin_participatory_processes.edit_participatory_process_path(participatory_process)
    end

    it "shows the Participa fields in the metadata section with their values" do
      within "#panel-metadata" do
        expect(page).to have_field("participatory_process[promoting_unit]", with: "Unitat promotora")
        expect(page).to have_field("participatory_process[facilitators]", with: "Entitats dinamitzadores")
        expect(page).to have_field("participatory_process[cost]", with: "1500.5")
        expect(page).to have_field("participatory_process[email]", with: "bustia@example.org")
        expect(page).to have_checked_field("participatory_process[has_summary_record]")
      end
    end

    it "does not show the hashtag field removed in Decidim 0.31" do
      expect(page).to have_no_field("participatory_process[hashtag]")
    end
  end
end
