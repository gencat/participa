# frozen_string_literal: true

require "rails_helper"

describe "Admin manages participatory processes", type: :system do
  let(:organization) { create(:organization) }
  let!(:type) { create(:type, organization: organization) }
  let!(:user) { create :user, :admin, :confirmed, organization: organization }

  let!(:participatory_process_group) { create(:participatory_process_group, organization: organization, title: { en: "Normativa", es: "Normativa", ca: "Normativa" }) }
  let!(:participatory_process) { create(:participatory_process, organization: organization, decidim_participatory_process_group_id: participatory_process_group.id) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "when participatory process group is 'Normativa'" do
    context "and there is not a proposal component" do
      it "show proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_link translated(participatory_process.title)
        expect(page).to have_text("Recordeu que heu d'activar el component propostes.")
      end
    end

    context "and there is a proposal component" do
      let!(:proposal_component) do
        create(:component, manifest_name: "proposals", participatory_space: participatory_process, published_at: Time.current)
      end

      it "not show proposal component alert" do
        visit decidim_admin_participatory_processes.participatory_processes_path
        click_link translated(participatory_process.title)
        expect(page).not_to have_text("Recordeu que heu d'activar el component propostes.")
      end
    end
  end
end
