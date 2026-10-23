# frozen_string_literal: true

require "rails_helper"
require "decidim/department_admin/test/factories"

module Decidim::Assemblies
  describe Admin::CreateAssembly do
    subject { described_class.new(form) }

    let(:organization) { create(:organization) }
    let(:department) { create(:department, organization:) }
    let(:current_user) { create(:department_admin, :confirmed, organization:, department:) }
    let(:assembly) { create(:assembly, organization:) }
    let(:form) do
      double(current_user:, current_organization: organization, participatory_processes_ids: [])
    end

    before { allow(subject).to receive(:resource).and_return(assembly) }

    it "assigns the department of the department admin author" do
      subject.send(:run_after_hooks)

      expect(assembly.reload.decidim_department_admin_department_id).to eq(department.id)
    end
  end
end
