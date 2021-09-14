# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses
  describe ParticipatoryProcessSerializer do
    describe "#serialize" do
      let(:participatory_process) { create(:participatory_process) }
      let(:subject) { described_class.new(participatory_process) }

      let(:proposals_component) { create(:component, participatory_space: participatory_process, manifest_name: :proposals) }
      let(:meetings_component) { create(:component, participatory_space: participatory_process, manifest_name: :meetings) }

      let(:organization) { participatory_process.organization }
      let(:user) { create :user, organization: organization }
      let(:user_group) { create(:user_group, :verified, organization: organization, users: [user]) }

      context "when there is a process_group" do
        let!(:process_group) { create :participatory_process_group, organization: organization }

        before do
          participatory_process.participatory_process_group= process_group
        end

        describe "#participatory_space" do
          it "contains the title of the process_group" do
            expect(subject.serialize).to include(participatory_space: process_group.title["ca"].downcase)
          end
        end
      end

      context "when there are proposals" do
        let!(:proposal) { create(:proposal, component: proposals_component) }

        describe "#proposals_num_authors" do
          it "includes proposal authors of type: User" do
            expect(subject.serialize).to include(proposals_num_authors: 1)
          end

          it "does not include proposal authors of type: UserGroup" do
            expect(subject.serialize).to include(proposals_num_author_entities: 0)
          end

          it "does not count proposal authors from meetings" do
            proposal.update(created_in_meeting: true)

            expect(subject.serialize).to include(proposals_num_authors: 0)
          end
        end

        describe "#proposals_num_author_entities" do
          before do
            proposal.coauthorships.clear
            proposal.coauthorships.create(author: user, user_group: user_group)
          end

          it "includes proposal authors of type: UserGroup" do
            expect(subject.serialize).to include(proposals_num_author_entities: 1)
          end

          it "does not include proposal authors of type: User" do
            expect(subject.serialize).to include(proposals_num_authors: 0)
          end

          it "does not count proposal authors from meetings" do
            proposal.update(created_in_meeting: true)

            expect(subject.serialize).to include(proposals_num_author_entities: 0)
          end
        end
      end

      context "when there are closed meetings" do
        let!(:meeting) { create(:meeting, :closed, component: meetings_component) }

        describe "#meetings_num_participants" do
          before do
            meeting.update(attendees_count: 5)
          end

          it "counts participants from closing report" do
            expect(subject.serialize).to include(meetings_num_participants: 5)
          end

          it "does not count User registrations" do
            create_list(:registration, 20, meeting: meeting)

            expect(subject.serialize).to include(meetings_num_participants: 5)
          end
        end

        describe "#meetings_num_entities" do
          before do
            meeting.update(attending_organizations: "CodiTramuntana")
          end

          it "counts Organizations from closing report" do
            expect(subject.serialize).to include(meetings_num_entities: 1)
          end

          it "does not count UserGroup registrations" do
            create_list(:registration, 20, meeting: meeting, user_group: user_group)

            expect(subject.serialize).to include(meetings_num_entities: 1)
          end
        end
      end

      context "when there are proposals and closed meetings" do
        let!(:proposal) { create(:proposal, component: proposals_component) }
        let!(:meeting) { create(:meeting, :closed, component: meetings_component) }

        describe "#total_num_participants" do
          before do
            meeting.update(attendees_count: 5)
          end

          it "sums proposals_num_authors and meetings_num_participants" do
            expect(subject.serialize).to include(total_num_participants: 6)
          end
        end

        describe "#total_num_entities" do
          before do
            proposal.coauthorships.clear
            proposal.coauthorships.create(author: user, user_group: user_group)
            meeting.update(attending_organizations: "CodiTramuntana")
          end

          it "sums proposals_num_author_entities and meetings_num_participants" do
            expect(subject.serialize).to include(total_num_entities: 2)
          end
        end
      end
    end
  end
end
