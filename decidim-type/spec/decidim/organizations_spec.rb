# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

describe "Organizations", type: :system do
  let(:organization) { create(:organization) }
  let(:locale) { "en" }
  let(:user) { create(:user, organization: organization, admin: true, nickname: "admin") }

  it "has created a relationship with user admin" do
    expect(organization.admins.or(organization.users_with_any_role)).to eq([user])
  end

  let(:organization_process_admin) { create(:organization) }
  let(:user_process_admin) { create(:user, organization: organization_process_admin, admin: false, nickname: "admin_process") }
  let(:participatory_process) { create(:participatory_process, organization: organization_process_admin, slug: 'processtest')}
  let(:participatory_process_user_role) { create(:participatory_process_user_role, user: user_process_admin, participatory_process: participatory_process)}

  it "has created a relationship with user process admin" do
    expect([participatory_process_user_role.user]).to eq(organization_process_admin.admins.or(organization_process_admin.users_with_any_role))
  end

  let(:organization_assembly_admin) { create(:organization) }
  let(:user_assembly_admin) { create(:user, organization: organization_assembly_admin, admin: false, nickname: "admin_assembly") }
  let(:assembly) { create(:assembly, organization: organization_assembly_admin, slug: 'assembliytest')}
  let(:assembly_user_role) { create(:assembly_user_role, user: user_assembly_admin, assembly: assembly)}

  it "has created a relationship with user process admin" do
    expect([assembly_user_role.user]).to eq(organization_assembly_admin.admins.or(organization_assembly_admin.users_with_any_role))
  end
end