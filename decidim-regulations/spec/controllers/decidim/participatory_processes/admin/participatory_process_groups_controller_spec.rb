# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses::Admin
  describe ParticipatoryProcessGroupsController, type: :controller do
    routes { Decidim::ParticipatoryProcesses::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, :confirmed, organization:) }
    let!(:processes_group) { create(:participatory_process_group, organization:) }
    let!(:regulations_group) { create(:participatory_process_group, organization:) }
    let!(:other_group) { create(:participatory_process_group, organization:) }

    before do
      # In Participa these ids are set in config/application.rb
      Rails.application.config.process = processes_group.id
      Rails.application.config.regulation = regulations_group.id

      request.env["decidim.current_organization"] = organization
      sign_in current_user
    end

    after do
      Rails.application.config.process = nil
      Rails.application.config.regulation = nil
    end

    describe "DELETE #destroy" do
      shared_examples "a protected group" do
        it "does not delete the group" do
          expect { delete :destroy, params: { id: group.id } }.not_to change(Decidim::ParticipatoryProcessGroup, :count)
        end

        it "redirects to the groups list with an alert" do
          delete :destroy, params: { id: group.id }

          expect(response).to redirect_to(participatory_process_groups_path)
          expect(flash[:alert]).to eq(I18n.t("decidim.regulations.admin.participatory_process_groups.destroy.protected"))
        end
      end

      context "when it is the processes group" do
        let(:group) { processes_group }

        it_behaves_like "a protected group"
      end

      context "when it is the regulations group" do
        let(:group) { regulations_group }

        it_behaves_like "a protected group"
      end

      context "when it is any other group" do
        it "deletes the group" do
          expect { delete :destroy, params: { id: other_group.id } }.to change(Decidim::ParticipatoryProcessGroup, :count).by(-1)
        end
      end
    end
  end
end
