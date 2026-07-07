# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

describe Decidim::Pages::Admin::UpdatePage do
  let(:form_klass) { Decidim::Pages::Admin::PageForm }

  let(:component) { create(:page_component) }
  let(:organization) { component.organization }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:attachment_params) { nil }
  let(:uploaded_documents) { [] }

  let(:form) do
    form_klass.from_params(
      form_params
    ).with_context(
      current_organization: organization,
      current_participatory_space: component.participatory_space,
      current_user: user,
      current_component: component
    )
  end

  let!(:page) { create(:page, component:) }

  describe "call" do
    let(:form_params) do
      {
        body: { en: "A reasonable proposal body" },
        add_documents: uploaded_documents
      }
    end

    let(:command) do
      described_class.new(form, page)
    end

    describe "when the form is not valid" do
      before do
        allow(form).to receive(:invalid?).and_return(true)
      end

      it "broadcast invalid" do
        expect { command.call }.to broadcast(:invalid)
      end

      it "does not update the page" do
        expect do
          command.call
        end.not_to change(page, :body)
      end
    end

    describe "when the form is valid" do
      it "broadcast ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "updates the page" do
        expect do
          command.call
        end.to change(page, :body)
      end

      context "when documents are uploaded" do
        let(:attachment_params) do
          blob = ActiveStorage::Blob.create_and_upload!(
            io: Rack::Test::UploadedFile.new(Decidim::Core::Engine.root.join("db", "seeds", "city.jpeg"), "image/jpeg"),
            filename: "city.jpeg",
            content_type: "image/jpeg"
          )
          {
            title: "My attachment",
            file: blob.signed_id
          }
        end
        let(:uploaded_documents) { [attachment_params] }

        it "creates an attachment for the page" do
          expect { command.call }.to change(Decidim::Attachment, :count).by(1)
          last_attachment = Decidim::Attachment.last
          expect(last_attachment.attached_to).to eq(page)
        end
      end

      context "when the uploaded attachment is not valid" do
        let(:attachment_params) do
          blob = ActiveStorage::Blob.create_and_upload!(
            io: Rack::Test::UploadedFile.new(Decidim::Core::Engine.root.join("db", "seeds", "city.jpeg"), "image/jpeg"),
            filename: "city.jpeg",
            content_type: "image/jpeg"
          )
          {
            title: "My attachment",
            file: blob.signed_id
          }
        end
        let(:uploaded_documents) { [attachment_params] }

        before do
          allow(command).to receive(:attachments_invalid?).and_return(true)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "does not update the page" do
          expect { command.call }.not_to change(page, :body)
        end

        it "does not create the attachment" do
          expect { command.call }.not_to change(Decidim::Attachment, :count)
        end
      end

      context "when an existing attachment is removed from the form" do
        let!(:existing_attachment) { create(:attachment, :with_pdf, attached_to: page) }
        let(:form_params) do
          {
            body: { en: "A reasonable proposal body" },
            documents: [],
            add_documents: uploaded_documents
          }
        end

        it "deletes the attachment that is no longer kept" do
          expect { command.call }.to change(Decidim::Attachment, :count).by(-1)
        end
      end

      context "when the page has an existing image attachment" do
        let!(:photo) { create(:attachment, :with_image, attached_to: page) }

        let(:edit_form) do
          form_klass.from_model(page).with_context(
            current_organization: organization,
            current_participatory_space: component.participatory_space,
            current_user: user,
            current_component: component
          )
        end

        let(:form_params) do
          {
            body: { en: "A reasonable proposal body" },
            documents: edit_form.documents.map(&:id),
            add_documents: uploaded_documents
          }
        end

        it "does not delete the existing image when it is kept" do
          expect { command.call }.not_to change(Decidim::Attachment, :count)
          expect(Decidim::Attachment.find_by(id: photo.id)).to be_present
        end
      end
    end
  end
end
