# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/MultipleMemoizedHelpers
module Decidim::ParticipatoryProcesses
  describe Admin::CreateParticipatoryProcess, versioning: true do
    subject { described_class.new(form) }

    let(:organization) { create(:organization) }
    let(:participatory_process_group) { create(:participatory_process_group, organization:) }
    let!(:admin) { create(:user, :admin, :confirmed, organization:, notification_settings: { participatory_space_news: "1" }) }
    let(:participatory_process_type) { create(:participatory_process_type, organization:) }
    let(:current_user) { create(:user, :admin, organization:) }
    let(:errors) { double.as_null_object }
    let(:related_process_ids) { [] }
    let(:weight) { 1 }
    let(:taxonomizations) do
      2.times.map { build(:taxonomization, taxonomy: create(:taxonomy, :with_parent, organization:), taxonomizable: nil) }
    end
    let(:form) do
      instance_double(
        Admin::ParticipatoryProcessForm,
        invalid?: invalid,
        title: { en: "title" },
        subtitle: { en: "subtitle" },
        weight:,
        slug: "slug",
        hashtag: "hashtag",
        meta_scope: { en: "meta scope" },
        hero_image: nil,
        promoted: nil,
        developer_group: { en: "developer group" },
        local_area: { en: "local" },
        target: { en: "target" },
        participatory_scope: { en: "participatory scope" },
        participatory_structure: { en: "participatory structure" },
        start_date: nil,
        end_date: nil,
        description: { en: "description" },
        short_description: { en: "short_description" },
        current_user:,
        current_organization: organization,
        organization:,
        private_space: false,
        taxonomizations:,
        errors:,
        related_process_ids:,
        participatory_process_group:,
        announcement: { en: "message" },
        cost: 123,
        has_summary_record: true,
        facilitators: "facilitators",
        promoting_unit: "promoting_unit",
        email: "email"
      )
    end
    let(:invalid) { false }

    context "when the process is not persisted" do
      before do
        invalid_process = build(:participatory_process, organization:)
        allow(Decidim.traceability).to receive(:create).and_return(invalid_process)
      end

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end

      it "not notify the admins" do
        expect(Decidim::EventsManager)
          .not_to receive(:publish)

        subject.call
      end
    end

    context "when everything is ok" do
      let(:process) { Decidim::ParticipatoryProcess.last }

      it "creates a participatory process" do
        expect { subject.call }.to change(Decidim::ParticipatoryProcess, :count).by(1)
      end

      it "traces the creation", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create)
          .with(Decidim::ParticipatoryProcess, current_user, kind_of(Hash))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)

        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
        expect(action_log.version.event).to eq "create"
      end

      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "notify to admins" do
        expect(Decidim::EventsManager)
          .to receive(:publish)

        subject.call
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
