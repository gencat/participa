# frozen_string_literal: true

require "rails_helper"
require "decidim/department_admin/test/factories"

module Decidim::ParticipatoryProcesses
  describe Admin::CreateParticipatoryProcess do
    subject { described_class.new(form) }

    let(:organization) { create(:organization) }
    let(:department) { create(:department, organization:) }
    let(:current_user) { create(:department_admin, :confirmed, organization:, department:) }
    let(:participatory_process) { create(:participatory_process, organization:) }
    let(:form) do
      double(current_user:, current_organization: organization, related_process_ids: [])
    end

    before { allow(subject).to receive(:resource).and_return(participatory_process) }

    it "assigns the department of the department admin author" do
      subject.send(:run_after_hooks)

      expect(participatory_process.reload.decidim_department_admin_department_id).to eq(department.id)
    end
  end
end
