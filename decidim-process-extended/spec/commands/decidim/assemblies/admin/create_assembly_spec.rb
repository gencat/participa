# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/MultipleMemoizedHelpers
module Decidim::Assemblies
  describe Admin::CreateAssembly do
    subject { described_class.new(form) }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, :confirmed, organization:) }
    let!(:admin) { create(:user, :admin, :confirmed, organization:, notification_settings: { participatory_space_news: "1" }) }
    let(:assembly_type) { create(:assemblies_type, organization:) }
    let(:scope) { create(:scope, organization:) }
    let(:area) { create(:area, organization:) }
    let(:errors) { double.as_null_object }
    let(:participatory_processes) do
      create_list(
        :participatory_process,
        3,
        organization:
      )
    end
    let(:related_process_ids) { [participatory_processes.map(&:id)] }

    let(:form) do
      instance_double(
        Admin::AssemblyForm,
        current_user:,
        invalid?: invalid,
        title: { en: "title" },
        subtitle: { en: "subtitle" },
        weight: 1,
        slug: "slug",
        hashtag: "hashtag",
        meta_scope: { en: "meta scope" },
        hero_image: nil,
        banner_image: nil,
        promoted: nil,
        developer_group: { en: "developer group" },
        local_area: { en: "local" },
        target: { en: "target" },
        participatory_scope: { en: "participatory scope" },
        participatory_structure: { en: "participatory structure" },
        description: { en: "description" },
        short_description: { en: "short_description" },
        current_organization: organization,
        scopes_enabled: true,
        scope:,
        area:,
        parent: nil,
        private_space: false,
        errors:,
        participatory_processes_ids: related_process_ids,
        purpose_of_action: { en: "purpose of action" },
        composition: { en: "composition of internal working groups" },
        assembly_type:,
        creation_date: 1.day.from_now,
        created_by: "others",
        created_by_other: { en: "other created by" },
        duration: 2.days.from_now,
        included_at: 5.days.from_now,
        closing_date: 5.days.from_now,
        closing_date_reason: { en: "closing date reason" },
        internal_organisation: { en: "internal organisation" },
        is_transparent: true,
        special_features: { en: "special features" },
        twitter_handler: "lorem",
        facebook_handler: "lorem",
        instagram_handler: "lorem",
        youtube_handler: "lorem",
        github_handler: "lorem",
        announcement: { en: "announcement_lorem" }
      )
    end
    let(:invalid) { false }

    context "when the assembly is not persisted" do
      let(:invalid_assembly) do
        instance_double(
          Decidim::Assembly,
          persisted?: false,
          valid?: false,
          errors: {
            hero_image: "File resolution is too large",
            banner_image: "File resolution is too large"
          }
        ).as_null_object
      end

      before do
        allow(Decidim::ActionLogger).to receive(:log).and_return(true)
        allow(Decidim::Assembly).to receive(:create).and_return(invalid_assembly)
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
      let(:assembly) { Decidim::Assembly.last }

      it "creates an assembly" do
        expect { subject.call }.to change(Decidim::Assembly, :count).by(1)
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
