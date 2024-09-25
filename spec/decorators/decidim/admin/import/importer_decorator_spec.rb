# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/import/proposal_creator_decorator"

describe Decidim::Admin::Import::Importer do
  subject { described_class.new(file: blob, reader: reader, creator: creator, context: context) }

  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:user) { create(:user, organization: organization) }
  let(:follower) { create(:user, organization: organization, notification_types: "all") }
  let(:context) do
    {
      current_organization: organization,
      current_user: user,
      current_component: current_component,
      current_participatory_space: participatory_process
    }
  end
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:current_component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }

  describe "#import!" do
    context "when imported collection are proposals" do
      let(:creator) { Decidim::Proposals::Import::ProposalCreator }
      let(:blob) { upload_test_file(Decidim::Dev.asset("import_proposals.csv"), return_blob: true) }
      let(:reader) { Decidim::Admin::Import::Readers::CSV }

      it_behaves_like "proposal importer"

      it "will execute notify_collection method" do
        subject.prepare
        expect(subject).to receive(:notify_collection)
        subject.import!
      end
    end

    context "when imported collection are answers proposals" do
      let!(:proposal_component) { create(:proposal_component, organization: organization) }
      let!(:proposal) { create(:proposal, component: proposal_component, id: 89_117) }
      let(:creator) { Decidim::Proposals::Import::ProposalAnswerCreator }
      let(:blob) { upload_test_file(Rails.root.join("lib", "assets", "import_answers.csv").to_s, return_blob: true) }
      let(:reader) { Decidim::Admin::Import::Readers::CSV }

      it "will execute notify_collection method" do
        subject.prepare
        expect(subject).to receive(:notify_collection)
        subject.import!
      end
    end
  end

  describe "#notify_collection" do
    context "when imported collection are proposals" do
      let(:creator) { Decidim::Proposals::Import::ProposalCreator }
      let(:blob) { upload_test_file(Decidim::Dev.asset("import_proposals.csv"), return_blob: true) }
      let(:reader) { Decidim::Admin::Import::Readers::CSV }

      before do
        participatory_process.followers << follower
        ActionMailer::Base.deliveries.clear
        allow(ProposalsMailer).to receive(:notify_massive_import).and_call_original
      end

      it_behaves_like "proposal importer"

      it "will call ProposalsMailer.notify_massive_import with the collection" do
        subject.prepare
        subject.import!
        expect(ProposalsMailer).to have_received(:notify_massive_import)
      end
    end

    context "when imported collection are answers proposals" do
      let!(:proposal) { create(:proposal, :evaluating, component: current_component, id: 89_117) }
      let(:creator) { Decidim::Proposals::Import::ProposalAnswerCreator }
      let(:blob) { upload_test_file(Rails.root.join("lib", "assets", "import_answers.csv").to_s, return_blob: true) }
      let(:reader) { Decidim::Admin::Import::Readers::CSV }

      before do
        participatory_process.followers << follower
        ActionMailer::Base.deliveries.clear
        allow(ProposalsAnswersMailer).to receive(:notify_massive_import).and_call_original
      end

      it "will call ProposalsMailer.notify_massive_import with the collection" do
        subject.prepare
        subject.import!
        expect(ProposalsAnswersMailer).to have_received(:notify_massive_import)
      end
    end
  end
end
