# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  # Please, check these anotations:
  # - Remove pinned package "workbox-webpack-plugin" in package.json
  it "Decidim version is >= 0.31" do
    expect(Decidim::VERSION).to be >= "0.31.0"
  end
end
