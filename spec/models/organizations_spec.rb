# frozen_string_literal: true

require "rails_helper"

describe "Organizations", type: :system do
  let(:organization) { create(:organization) }

  context "with backoffice admins" do
    let!(:user) { create(:user, organization: organization, admin: true, nickname: "admin") }

    it "has created a relationship with user admin" do
      expect(organization.admins.or(organization.users_with_any_role)).to eq([user])
    end
  end

  context "with process admins" do
    let!(:user_process_admin) { create(:user, organization: organization, admin: false, nickname: "admin_process") }
    let!(:participatory_process_user_role) { create(:participatory_process_user_role, user: user_process_admin, participatory_process: participatory_process)}
    let(:participatory_process) { create(:participatory_process, organization: organization, slug: 'processtest')}

    it "has created a relationship with user process admin" do
      expect(organization.users_with_any_role).to eq([participatory_process_user_role.user])
    end
  end

  context "with assembly admins" do
    let!(:user_assembly_admin) { create(:user, organization: organization, admin: false, nickname: "admin_assembly") }
    let!(:assembly_user_role) { create(:assembly_user_role, user: user_assembly_admin, assembly: assembly)}
    let(:assembly) { create(:assembly, organization: organization, slug: 'assembliytest')}

    it "has created a relationship with user process admin" do
      expect(organization.users_with_any_role).to eq([assembly_user_role.user])
    end
  end

  context "with department_admins" do
    let!(:department_admin_user) { create(:user, admin: false, nickname: "admin_assembly", roles: ["department_admin"], organization: organization) }

    it "returns the department_admin_user as a :users_with_any_role" do
      expect(organization.users_with_any_role).to eq([department_admin_user])
    end
  end
end