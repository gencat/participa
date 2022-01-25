# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  it "remove templates translations when Decidim v0.25" do
    # remove tmp override lib/decidim/has_private_users.rb? https://github.com/gencat/participa/pull/195
    # remove config/locales/ca_templates.yml and config/locales/es_templates.yml
    # when this translations are in Decidim 0.25
    expect(Decidim.version).to be < "0.25"
  end
end
