# frozen_string_literal: true

require "rails_helper"

describe "new registration", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "display feder logo on footer" do
    expect(page).to have_content "Fons Europeu de Desenvolupament Regional"
  end
end
