# frozen_string_literal: true

require "spec_helper"

describe Decidim::ParticipatoryProcesses::ContentBlocks::HighlightedProcessesCell, type: :cell do
  subject { cell(content_block.cell, content_block) }

  let(:organization) { create(:organization) }
  let(:content_block) { create(:content_block, organization:, manifest_name: :highlighted_processes, scope_name: :homepage, settings:) }
  let(:settings) { { "max_results" => "3" } }
  let(:regulations_group) { create(:participatory_process_group, organization:) }
  let!(:processes) { create_list(:participatory_process, 4, :published, :promoted, organization:) }
  let!(:regulation) { create(:participatory_process, :published, :promoted, organization:, participatory_process_group: regulations_group) }

  controller Decidim::PagesController

  before do
    # In Participa this id is set in config/application.rb
    Rails.application.config.regulation = regulations_group.id
    allow(controller).to receive(:current_organization).and_return(organization)
  end

  after do
    Rails.application.config.regulation = nil
  end

  it "does not show the regulations" do
    expect(subject.send(:highlighted_processes)).not_to include(regulation)
  end

  it "shows up to max_results processes" do
    expect(subject.send(:highlighted_processes).size).to eq(3)
  end

  context "when there are promoted groups" do
    let!(:promoted_group) { create(:participatory_process_group, :promoted, organization:) }

    it "leaves room for the groups so the block does not show more than max_results" do
      expect(subject.send(:highlighted_processes).size).to eq(2)
      expect(subject.highlighted_spaces.size).to eq(3)
    end
  end

  context "when the promoted groups fill the block" do
    let!(:promoted_groups) { create_list(:participatory_process_group, 3, :promoted, organization:) }

    it "does not show any process" do
      expect(subject.send(:highlighted_processes)).to eq([])
    end
  end
end
