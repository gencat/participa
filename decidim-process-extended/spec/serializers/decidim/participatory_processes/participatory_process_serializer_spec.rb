# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses
  describe ParticipatoryProcessSerializer do
    subject { described_class.new(resource) }

    describe "#serialize" do
      let(:participatory_process) { create(:participatory_process, cost: 123) }
      let(:subject) { described_class.new(participatory_process) }

      it "includes custom fields" do
        expect(subject.serialize).to include(cost: participatory_process.cost)
        expect(subject.serialize).to include(has_record: participatory_process.has_summary_record)
        expect(subject.serialize).to include(facilitators: participatory_process.facilitators)
        expect(subject.serialize).to include(promoting_unit: participatory_process.promoting_unit)
        expect(subject.serialize).to include(email: participatory_process.email)
      end
    end
  end
end
