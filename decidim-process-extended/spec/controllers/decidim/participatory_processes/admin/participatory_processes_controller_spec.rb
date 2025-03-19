# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses::Admin
  describe ParticipatoryProcessesController, type: :controller do
    routes { Decidim::ParticipatoryProcesses::AdminEngine.routes }
    let(:organization) { create :organization, available_locales: [:ca, :en, :es] }
    let(:current_user) { create :user, :admin, :confirmed, organization: }
    let(:participatory_process) do
      create(:participatory_process, organization:,
                                     hero_image: nil, banner_image: nil)
    end

    let(:participatory_process_params) do
      {
        title: participatory_process.title,
        subtitle: participatory_process.subtitle,
        weight: participatory_process.weight,
        description: participatory_process.description,
        short_description: participatory_process.short_description,
        slug: participatory_process.slug,
        scopes_enabled: participatory_process.scopes_enabled
      }
    end

    before do
      request.env["decidim.current_organization"] = organization
      sign_in current_user
    end

    describe "PATCH #update" do
      context "when updating participatory process" do
        it "assigns default images" do
          expect(ParticipatoryProcessForm).to receive(:from_params).with(hash_including(id: participatory_process.id.to_s)).and_call_original
          patch :update, params: { slug: participatory_process.id, participatory_process: participatory_process_params }

          expect(response).to redirect_to(edit_participatory_process_path(participatory_process.slug))
          expect(response).to have_http_status(:found)

          expect(participatory_process.reload.hero_image.attachment&.blob&.filename).not_to eq(nil)
          expect(participatory_process.reload.banner_image.attachment&.blob&.filename).not_to eq(nil)
        end
      end
    end
  end
end
