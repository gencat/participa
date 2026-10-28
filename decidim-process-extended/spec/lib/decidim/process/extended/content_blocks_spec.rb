# frozen_string_literal: true

require "spec_helper"

describe "Participatory process homepage content blocks" do
  let(:manifest) { Decidim.content_blocks.for(:participatory_process_homepage).find { |block| block.name == :social_networks_metadata } }

  it "registers the social networks content block" do
    expect(manifest).to be_present
    expect(manifest.cell).to eq("decidim/content_blocks/participatory_space_social_networks")
  end
end
