# frozen_string_literal: true

require "rails_helper"

describe "Admin manages the list mode of the children assemblies content block", type: :system do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:assembly) { create(:assembly, :published, organization:) }

  let(:list_mode_checkbox) { "input[type='checkbox'][name='content_block[settings][list_mode]']" }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when editing the related assemblies content block of an assembly" do
    let!(:content_block) do
      create(:content_block, organization:, scope_name: :assembly_homepage, manifest_name: :related_assemblies,
                             scoped_resource_id: assembly.id, settings: { "max_results" => "6" })
    end

    before do
      visit decidim_admin_assemblies.edit_assembly_landing_page_content_block_path(assembly, content_block)
    end

    it "shows the list mode checkbox unchecked by default, with its help text" do
      expect(page).to have_css("input[type='number'][name='content_block[settings][max_results]']")
      expect(page).to have_css(list_mode_checkbox)
      expect(find(list_mode_checkbox)).not_to be_checked
      expect(page).to have_css(".help-text", text: I18n.t("decidim.assemblies.admin.content_blocks.children_assemblies.list_mode_help"))
    end

    it "saves the list mode setting" do
      find(list_mode_checkbox).check
      find("form.edit_content_block [type='submit']").click

      expect(page).to have_current_path(decidim_admin_assemblies.edit_assembly_landing_page_path(assembly))
      expect(content_block.reload.settings.list_mode).to be(true)

      visit decidim_admin_assemblies.edit_assembly_landing_page_content_block_path(assembly, content_block)
      expect(find(list_mode_checkbox)).to be_checked
    end
  end

  context "when editing the related assemblies content block of a participatory process" do
    let!(:participatory_process) { create(:participatory_process, organization:) }
    let!(:content_block) do
      create(:content_block, organization:, scope_name: :participatory_process_homepage, manifest_name: :related_assemblies,
                             scoped_resource_id: participatory_process.id)
    end

    it "does not show the list mode checkbox" do
      visit decidim_admin_participatory_processes.edit_participatory_process_landing_page_content_block_path(participatory_process, content_block)

      expect(page).to have_css("input[type='number'][name='content_block[settings][max_results]']")
      expect(page).to have_no_css(list_mode_checkbox)
    end
  end

  context "when editing the highlighted assemblies content block of the homepage" do
    let!(:content_block) { create(:content_block, organization:, scope_name: :homepage, manifest_name: :highlighted_assemblies) }

    it "does not show the list mode checkbox" do
      visit decidim_admin.edit_organization_homepage_content_block_path(content_block)

      expect(page).to have_css("input[type='number'][name='content_block[settings][max_results]']")
      expect(page).to have_no_css(list_mode_checkbox)
    end
  end
end
