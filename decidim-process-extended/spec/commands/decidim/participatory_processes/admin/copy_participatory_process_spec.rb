# frozen_string_literal: true

require "spec_helper"

module Decidim::ParticipatoryProcesses
  describe Admin::CopyParticipatoryProcess do
    subject { described_class.new(form, participatory_process) }

    let(:organization) { create(:organization) }
    let(:current_user) { create(:user, :admin, organization:) }
    let!(:participatory_process) do
      create(:participatory_process,
             organization:,
             twitter_handler: "twitter_handler",
             facebook_handler: "facebook_handler",
             instagram_handler: "instagram_handler",
             youtube_handler: "youtube_handler",
             github_handler: "github_handler")
    end
    let(:form) do
      instance_double(
        Admin::ParticipatoryProcessCopyForm,
        invalid?: false,
        title: { en: "title" },
        copy_steps?: false,
        copy_components?: false,
        copy_landing_page_blocks?: false,
        slug: "duplicated-slug",
        current_user:
      )
    end

    it "copies the social handlers" do
      expect { subject.call }.to broadcast(:ok)

      copied_process = Decidim::ParticipatoryProcess.last
      expect(copied_process.slug).to eq("duplicated-slug")
      expect(copied_process.twitter_handler).to eq("twitter_handler")
      expect(copied_process.facebook_handler).to eq("facebook_handler")
      expect(copied_process.instagram_handler).to eq("instagram_handler")
      expect(copied_process.youtube_handler).to eq("youtube_handler")
      expect(copied_process.github_handler).to eq("github_handler")
    end
  end
end
