# frozen_string_literal: true

require "rails_helper"

describe "Admin static page form", type: :system do
  let(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:tos_page) { organization.static_pages.find_by!(slug: "terms-of-service") }
  let!(:other_page) { create(:static_page, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  describe "editing a terms-of-service static page" do
    it "does not show the attachment fields" do
      visit decidim_admin.edit_static_page_path(tos_page)

      expect(page).to have_no_css("label", text: /documents/i)
      expect(page).to have_no_css("label", text: /imatge/i)
    end
  end

  describe "editing a regular static page" do
    it "shows the attachment fields" do
      visit decidim_admin.edit_static_page_path(other_page)

      expect(page).to have_css("legend", text: I18n.t("decidim.admin.static_pages.form.attachment_legend"))
    end
  end
end
