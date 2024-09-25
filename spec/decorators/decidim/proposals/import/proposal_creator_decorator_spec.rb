# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/import/proposal_creator"

describe Decidim::Proposals::Import::ProposalCreator do
  subject { described_class.new(data, context) }

  let!(:moment) { Time.current }
  let(:data) do
    {
      id: 1337,
      "id" => "101",
      category: category,
      scope: scope,
      :"title/en" => Faker::Lorem.sentence,
      :"body/en" => Faker::Lorem.paragraph(sentence_count: 3),
      address: "#{Faker::Address.street_name}, #{Faker::Address.city}",
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      component: component,
      published_at: moment
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
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }
  let(:scope) { create :scope, organization: organization }
  let(:category) { create :category, participatory_space: participatory_process }

  describe "#finish_without_notif!" do
    context "when a proposals file are created" do
      it "saves the proposal" do
        record = subject.produce
        subject.finish!
        expect(record.new_record?).to be(false)
      end

      it "creates admin log" do
        record = subject.produce
        expect { subject.finish! }.to change(Decidim::ActionLog, :count).by(1)
        expect(Decidim::ActionLog.last.user).to eq(user)
        expect(Decidim::ActionLog.last.resource).to eq(record)
        expect(Decidim::ActionLog.last.visibility).to eq("admin-only")
      end

      it "does not notify the import with ActiveSupport::Notifications" do
        subject.produce
        subject.finish_without_notif!
        expect(subject).not_to receive(:notify)
      end
    end
  end
end
