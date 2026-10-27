# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::DuplicateParticipatoryProcess do
    subject { described_class.new(form, participatory_process) }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, :confirmed, organization:) }
    let!(:participatory_process) do
      create(:participatory_process, organization:, cost: 1500.5, email: "bustia@example.org", has_summary_record: true,
                                     promoting_unit: "Unitat promotora", facilitators: "Entitats dinamitzadores")
    end
    let(:form) do
      instance_double(
        Admin::ParticipatoryProcessDuplicateForm,
        invalid?: false,
        title: { en: "Duplicated process" },
        slug: "duplicated-slug",
        duplicate_steps?: false,
        duplicate_components?: false,
        current_user:
      )
    end
    let(:duplicated_process) { Decidim::ParticipatoryProcess.find_by(slug: "duplicated-slug") }

    it "broadcasts ok" do
      expect { subject.call }.to broadcast(:ok)
    end

    it "copies the Participa fields" do
      subject.call

      expect(duplicated_process).to have_attributes(
        cost: participatory_process.cost,
        email: "bustia@example.org",
        has_summary_record: true,
        promoting_unit: "Unitat promotora",
        facilitators: "Entitats dinamitzadores"
      )
    end
  end
end
