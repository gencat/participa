# frozen_string_literal: true

require "rails_helper"

describe "Homepage", type: :system do
  include Decidim::SanitizeHelper

  let!(:organization) do
    create(
      :organization,
      name: "Participa Gencat",
      default_locale: :ca,
      available_locales: [:ca, :en, :es]
    )
  end
  let!(:hero) { create(:content_block, organization: organization, scope_name: :homepage, manifest_name: :hero, settings: { "welcome_text_ca"=>"Benvinguda a Participa Gencat" }) }
  let!(:sub_hero) { create(:content_block, organization: organization, scope_name: :homepage, manifest_name: :sub_hero) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path(locale: I18n.locale)
  end

  it "loads and shows organization name and main blocks" do
    visit decidim.root_path

    expect(page).to have_content("Participa Gencat")
    within " .hero .hero__title" do
      expect(page).to have_content("Benvinguda a Participa Gencat")
    end
    within "section#sub_hero" do
      subhero_msg= translated(organization.description).gsub(%r{</p>\s+<p>}, "<br><br>").gsub(%r{<p>(((?!</p>).)*)</p>}mi, "\\1").gsub(%r{<script>(((?!</script>).)*)</script>}mi, "\\1")
      expect(page).to have_content(subhero_msg)
    end
  end
end
