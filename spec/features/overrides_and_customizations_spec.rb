# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  it "remove config/initializers/doorkeeper.rb and remove translations in admin.yml and surveys.yml after Decidim v0.28" do
    # remove config/initializers/doorkeeper.rb as it is already configured in that version
    # xx_admin.yml and xx_surveys.yml have multiple translations that
    # need to be removed if PR https://github.com/decidim/decidim/pull/11450/files gets merged into v0.28
    expect(Decidim.version).to be < "0.28"
  end
end
