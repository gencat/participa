# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  it "remove config/initializers/doorkeeper.rb after Decidim v0.28" do
    # remove config/initializers/doorkeeper.rb after Decidim v0.28 as it is already configured in that version
    expect(Decidim.version).to be < "0.28"
  end
end
