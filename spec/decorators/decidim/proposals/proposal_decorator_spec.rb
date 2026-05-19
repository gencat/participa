# frozen_string_literal: true

require "rails_helper"

describe Decidim::Proposals::Proposal do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:component) { create(:component, manifest_name: :proposals, participatory_space: participatory_process) }

  let!(:proposal_no_attachments) { create(:proposal, component:) }
  let!(:proposal_one_attachment) { create(:proposal, component:) }
  let!(:proposal_two_attachments) { create(:proposal, component:) }

  before do
    create(:attachment, attached_to: proposal_one_attachment)
    create(:attachment, attached_to: proposal_two_attachments)
    create(:attachment, attached_to: proposal_two_attachments)
  end

  let(:scoped_proposals) { described_class.where(component:) }

  describe ".sort_by_attachments_count_asc" do
    subject { scoped_proposals.sort_by_attachments_count_asc.to_a }

    it "orders proposals by ascending attachment count" do
      expect(subject.index(proposal_no_attachments)).to be < subject.index(proposal_one_attachment)
      expect(subject.index(proposal_one_attachment)).to be < subject.index(proposal_two_attachments)
    end
  end

  describe ".sort_by_attachments_count_desc" do
    subject { scoped_proposals.sort_by_attachments_count_desc.to_a }

    it "orders proposals by descending attachment count" do
      expect(subject.index(proposal_two_attachments)).to be < subject.index(proposal_one_attachment)
      expect(subject.index(proposal_one_attachment)).to be < subject.index(proposal_no_attachments)
    end
  end
end
