# frozen_string_literal: true

require "rails_helper"

module Decidim::ParticipatoryProcesses::Admin

  describe ParticipatoryProcessesController, type: :controller do
    routes { Decidim::ParticipatoryProcesses::AdminEngine.routes }
    let(:organization) { create :organization, available_locales: [:es, :ca, :oc] }
    let(:current_user) { create :user, :admin, :confirmed, organization: organization }
    let(:participatory_process) { create(:participatory_process, organization: organization,
      hero_image: nil, banner_image: nil) }
    let(:participatory_process_params) do
      {
        slug: participatory_process.slug,
        hero_image: "",
        banner_image: ""
      }
    end

    before do
      request.env["decidim.current_organization"] = organization
      sign_in current_user
    end
  
    describe "PATCH #update" do
      context "updates participatory process" do
        xit "assigns default images" do
          expect(ParticipatoryProcessForm).to receive(:from_params).with(hash_including(id: participatory_process.id.to_s)).and_call_original
          patch :update, params: { slug: participatory_process.id, participatory_process: participatory_process_params }

          expect(response).to redirect_to(edit_participatory_process_path(participatory_process.slug))
          expect(response).to have_http_status(:ok)

          expect(participatory_process.reload.hero_image.attachment&.blob&.filename).not_to eq(nil)
          expect(participatory_process.reload.banner_image.attachment&.blob&.filename).not_to eq(nil)
        end
      end
    end
  end
end
