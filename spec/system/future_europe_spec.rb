# frozen_string_literal: true

require "rails_helper"

describe "Futur Europa redirect", type: :system do
  let(:title_ca) { "El futur d'Europa" }
  let!(:process) { create(:participatory_process, slug: "FuturEuropa", title: { ca: title_ca }) }
  let!(:organization) { process.organization }

  before do
    switch_to_host(organization.host)
    # visit decidim.root_path
  end

  it "redirects to the process when /futur-europa is visited" do
    visit "/futur-europa"
    expect(page).to have_content(title_ca)
  end
end
