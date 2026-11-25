# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require_relative "../../../support/pdf_security_helper"

describe Decidim::Admin::UpdateAttachment do
  let(:organization) { create(:organization) }
  let(:process) { create(:participatory_process, organization:) }
  let!(:attachment) { create(:attachment, :with_pdf, attached_to: process) }
  let(:user) { create(:user, organization:) }
  let(:forbidden_blob) { upload_pdf(generated_pdf(action: { S: :Launch, F: "example" })) }
  let(:form_errors) { ActiveModel::Errors.new(Decidim::AttachmentForm.new) }
  let(:form) do
    double(
      title: { en: "Updated attachment" },
      description: { en: "Description" },
      file: forbidden_blob.signed_id,
      link: "",
      attachment_collection: nil,
      current_user: user,
      weight: 2,
      errors: form_errors
    )
  end

  before do
    allow(form).to receive(:invalid?).and_return(false)
  end

  it "keeps the existing file when a replacement PDF is rejected" do
    original_blob_id = attachment.file.blob.id
    action_logs_count = Decidim::ActionLog.count

    expect { described_class.call(attachment, form) }.to broadcast(:invalid)

    expect(attachment.reload.file.blob.id).to eq(original_blob_id)
    expect(Decidim::ActionLog.count).to eq(action_logs_count)
    expect(form.errors[:file]).not_to be_empty
  end
end
