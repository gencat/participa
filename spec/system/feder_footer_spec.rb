# frozen_string_literal: true

require "rails_helper"

describe "new registration", type: :system do
  let(:organization) { create :organization }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "display feder logo on footer on homepage" do
    expect(page).to have_content "Fons Europeu de Desenvolupament Regional"
  end

  it "display feder logo on footer on user registration page" do
    expect(page).to have_content "Fons Europeu de Desenvolupament Regional"
  end
end
