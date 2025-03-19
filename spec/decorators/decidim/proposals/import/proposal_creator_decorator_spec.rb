# frozen_string_literal: true

require "rails_helper"
require "decidim/proposals/import/proposal_creator"

describe Decidim::Proposals::Import::ProposalCreator do
  subject { described_class.new(data, context) }

  let!(:moment) { Time.current }
  let(:data) do
    {
      id: 1337,
      category:,
      scope:,
      "title/en": Faker::Lorem.sentence,
      "body/en": Faker::Lorem.paragraph(sentence_count: 3),
      address: "#{Faker::Address.street_name}, #{Faker::Address.city}",
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      component:,
      published_at: moment,
      "external_author/name": "Extenal author name"
    }
  end
  let(:organization) { create(:organization, available_locales: [:en]) }
  let(:user) { create(:user, organization:) }
  let(:meeting) { create(:meeting) }
  let(:context) do
    {
      current_organization: organization,
      current_user: user,
      current_component: component,
      current_participatory_space: participatory_process
    }
  end
  let(:participatory_process) { create :participatory_process, organization: }
  let(:component) { create :component, manifest_name: :proposals, participatory_space: participatory_process }
  let(:scope) { create :scope, organization: }
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
    end
  end

  describe "#produce" do
    it "makes a new proposal with external author" do
      record = subject.produce

      expect(record).to be_a(Decidim::Proposals::Proposal)
      expect(record.category).to eq(category)
      expect(record.scope).to eq(scope)
      expect(record.title["en"]).to eq(data[:"title/en"])
      expect(record.body["en"]).to eq(data[:"body/en"])
      expect(record.address).to eq(data[:address])
      expect(record.latitude).to eq(data[:latitude])
      expect(record.longitude).to eq(data[:longitude])
      expect(record.published_at).to be >= (moment)
      expect(record.coauthorships.first.author.name).to eq(data["external_author/name".to_sym])
    end
  end

  describe "#produce with meeting_url" do
    let(:data) do
      {
        id: 1337,
        category:,
        scope:,
        "title/en": Faker::Lorem.sentence,
        "body/en": Faker::Lorem.paragraph(sentence_count: 3),
        address: "#{Faker::Address.street_name}, #{Faker::Address.city}",
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
        component:,
        published_at: moment,
        "meeting_url": "url_meeting/#{meeting.id}"
      }
    end

    it "makes a new proposal with location" do
      record = subject.produce

      expect(record).to be_a(Decidim::Proposals::Proposal)
      expect(record.category).to eq(category)
      expect(record.scope).to eq(scope)
      expect(record.title["en"]).to eq(data[:"title/en"])
      expect(record.body["en"]).to eq(data[:"body/en"])
      expect(record.address).to eq(data[:address])
      expect(record.latitude).to eq(data[:latitude])
      expect(record.longitude).to eq(data[:longitude])
      expect(record.published_at).to be >= (moment)
      expect(record.coauthorships.first.author.id).to eq(meeting.id)
    end
  end
end
