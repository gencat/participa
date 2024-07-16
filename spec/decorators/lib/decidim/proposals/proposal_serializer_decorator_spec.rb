# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/MultipleMemoizedHelpers
module Decidim
  module Proposals
    describe ProposalSerializer do
      subject do
        described_class.new(proposal)
      end

      let!(:proposal) { create(:proposal, :accepted, body: body) }
      let!(:category) { create(:category, participatory_space: component.participatory_space) }
      let!(:scope) { create(:scope, organization: component.participatory_space.organization) }
      let(:participatory_process) { component.participatory_space }
      let(:component) { proposal.component }

      let!(:meetings_component) { create(:component, manifest_name: "meetings", participatory_space: participatory_process) }
      let(:meetings) { create_list(:meeting, 2, :published, component: meetings_component) }

      let!(:proposals_component) { create(:component, manifest_name: "proposals", participatory_space: participatory_process) }
      let(:other_proposals) { create_list(:proposal, 2, component: proposals_component) }
      let(:body) { Decidim::Faker::Localized.localized { ::Faker::Lorem.sentences(number: 3).join("\n") } }

      let(:expected_answer) do
        answer = proposal.answer
        Decidim.available_locales.each_with_object({}) do |locale, result|
          result[locale.to_s] = if answer.is_a?(Hash)
                                  answer[locale.to_s] || ""
                                else
                                  ""
                                end
        end
      end

      before do
        proposal.update!(category: category)
        proposal.update!(scope: scope)
        proposal.link_resources(meetings, "proposals_from_meeting")
        proposal.link_resources(other_proposals, "copied_from_component")
      end

      describe "#serialize" do
        let(:serialized) { subject.serialize }

        it "serializes the authors names" do
          expect(serialized).to include(authors_names: proposal.authors.pluck(:name))
        end

        it "serializes the authors emails" do
          expect(serialized).to include(authors_email: proposal.authors.pluck(:emails))
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
