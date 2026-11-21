# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses
  describe ParticipatoryProcessSerializer do
    subject { described_class.new(resource) }

    describe "#serialize" do
      let(:participatory_process) { create(:participatory_process, cost: 123, twitter_handler: "twitter_handler", github_handler: "github_handler") }
      let(:subject) { described_class.new(participatory_process) }

      it "includes custom fields" do
        expect(subject.serialize).to include(cost: participatory_process.cost)
        expect(subject.serialize).to include(has_record: participatory_process.has_summary_record?)
        expect(subject.serialize).to include(facilitators: participatory_process.facilitators)
        expect(subject.serialize).to include(promoting_unit: participatory_process.promoting_unit)
        expect(subject.serialize).to include(email: participatory_process.email)
        expect(subject.serialize).to include(twitter_handler: "twitter_handler")
        expect(subject.serialize).to include(facebook_handler: nil)
        expect(subject.serialize).to include(instagram_handler: nil)
        expect(subject.serialize).to include(youtube_handler: nil)
        expect(subject.serialize).to include(github_handler: "github_handler")
      end
    end
  end
end
