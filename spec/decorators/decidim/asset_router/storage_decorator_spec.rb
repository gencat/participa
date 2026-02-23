# frozen_string_literal: true

require "rails_helper"

describe Decidim::AssetRouter::Storage do
  let!(:organization) { create(:organization) }
  let!(:process) { create(:participatory_process, organization:) }
  let!(:attachment) { create(:attachment, attached_to: process) }
  let(:blob) { attachment.file.blob }
  let(:router) { described_class.new(blob) }

  describe "#url" do
    subject { router.url }

    it "generates proxy URLs instead of disk URLs" do
      expect(subject).to include("/rails/active_storage/blobs/proxy/")
      expect(subject).not_to include("/rails/active_storage/disk/")
    end

    it "generates only_path URLs (no host required)" do
      expect(subject).to start_with("/")
      expect(subject).not_to match(%r{^https?://})
    end

    it "includes the blob signed_id in the URL" do
      expect(subject).to include(blob.signed_id)
    end

    it "includes the filename in the URL" do
      expect(subject).to include(blob.filename.to_s)
    end

    it "generates the same URL every time" do
      expect(router.url).to eq(router.url)
    end
  end
end
