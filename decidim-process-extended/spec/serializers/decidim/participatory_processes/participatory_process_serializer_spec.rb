# frozen_string_literal: true

require "spec_helper"

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

      it "includes custom fields" do
        expect(subject.serialize).to include(id: participatory_process.cost)
        expect(subject.serialize).to include(id: participatory_process.has_summary_record)
        expect(subject.serialize).to include(id: participatory_process.facilitators)
        expect(subject.serialize).to include(id: participatory_process.promoting_unit)
        expect(subject.serialize).to include(id: participatory_process.email)
      end
    end
  end
end
