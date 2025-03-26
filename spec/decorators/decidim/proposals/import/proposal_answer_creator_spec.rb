# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/import/proposal_answer_creator"

describe Decidim::Proposals::Import::ProposalAnswerCreator do
  subject { described_class.new(data, context) }

  let(:proposal) { create(:proposal, state: state, component: component) }
  let!(:moment) { Time.current }
  let(:data) do
    {
      id: proposal.id,
      state: state,
      "answer/en": Faker::Lorem.paragraph
    }
  end
  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:user) { create(:user, organization: organization) }
  let(:context) do
    {
      current_organization: organization,
      current_user: user,
      current_component: component,
      current_participatory_space: participatory_process
    }
  end
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:component, manifest_name: :proposals, participatory_space: participatory_process) }
  let(:state) { %w(evaluating accepted rejected).sample }

  describe "#finish_without_notif!" do
    it "saves the answer proposal" do
      record = subject.produce
      subject.finish!
      expect(record.new_record?).to be(false)
    end

    it "creates an admin log record" do
      record = subject.produce
      subject.finish!

      log = Decidim::ActionLog.last
      expect(log.resource).to eq(record)
      expect(log.action).to eq("answer")
    end

    context "when proposal state changes" do
      let!(:proposal) { create(:proposal, :evaluating, component: component) }
      let(:state) { "accepted" }

      it "returns broadcast :ok" do
        expect(subject.finish!).to eq({ ok: [] })
      end
    end
  end
end
