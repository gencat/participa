# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

describe Decidim::Admin::UpdateStaticPage do
  let(:form_klass) { Decidim::Admin::StaticPageForm }

  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:attachment_params) { nil }
  let(:uploaded_documents) { [] }

  let(:form) do
    form_klass.from_params(
      form_params
    ).with_context(
      current_organization: organization,
      current_user: user
    )
  end

  let!(:static_page) { create(:static_page, organization:) }

  describe "call" do
    let(:form_params) do
      {
        static_page: {
          id: static_page.id,
          slug: static_page.slug,
          title: { en: "Updated title" },
          content: { en: "<p>Updated content</p>" },
          weight: 5,
          allow_public_access: true,
          add_documents: uploaded_documents
        }
      }
    end

    let(:command) do
      described_class.new(form, static_page)
    end

    describe "when the form is not valid" do
      before do
        allow(form).to receive(:invalid?).and_return(true)
      end

      it "broadcast invalid" do
        expect { command.call }.to broadcast(:invalid)
      end

      it "does not update the static page" do
        expect do
          command.call
        end.not_to(change { static_page.reload.content })
      end
    end

    describe "when the form is valid" do
      it "broadcast ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "updates the static page content" do
        expect do
          command.call
        end.to(change { static_page.reload.content["en"] })
      end

      it "updates the static page title" do
        expect do
          command.call
        end.to(change { static_page.reload.title["en"] }.to("Updated title"))
      end

      it "updates the static page weight" do
        expect do
          command.call
        end.to(change { static_page.reload.weight }.to(5))
      end

      it "updates the static page allow_public_access" do
        expect do
          command.call
        end.to(change { static_page.reload.allow_public_access }.to(true))
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

        it "creates an attachment for the static page" do
          expect { command.call }.to change(Decidim::Attachment, :count).by(1)
          last_attachment = Decidim::Attachment.last
          expect(last_attachment.attached_to).to eq(static_page)
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

        it "does not update the static page" do
          expect do
            command.call
          end.not_to(change { static_page.reload.title })
        end

        it "does not create the attachment" do
          expect { command.call }.not_to change(Decidim::Attachment, :count)
        end
      end

      context "when an existing attachment is removed from the form" do
        let!(:existing_attachment) { create(:attachment, :with_pdf, attached_to: static_page) }
        let(:form_params) do
          {
            static_page: {
              id: static_page.id,
              slug: static_page.slug,
              title: { en: "Updated title" },
              content: { en: "<p>Updated content</p>" },
              weight: 5,
              allow_public_access: true,
              documents: [],
              add_documents: uploaded_documents
            }
          }
        end

        it "deletes the attachment that is no longer kept" do
          expect { command.call }.to change(Decidim::Attachment, :count).by(-1)
        end
      end

      context "when the page has an existing image attachment" do
        let!(:photo) { create(:attachment, :with_image, attached_to: static_page) }

        let(:edit_form) do
          form_klass.from_model(static_page).with_context(
            current_organization: organization,
            current_user: user
          )
        end

        let(:form_params) do
          {
            static_page: {
              id: static_page.id,
              slug: static_page.slug,
              title: { en: "Updated title" },
              content: { en: "<p>Updated content</p>" },
              weight: 5,
              allow_public_access: true,
              documents: edit_form.documents.map(&:id),
              add_documents: uploaded_documents
            }
          }
        end

        it "does not delete the existing image when it is kept" do
          expect { command.call }.not_to change(Decidim::Attachment, :count)
          expect(Decidim::Attachment.find_by(id: photo.id)).to be_present
        end
      end
    end
  end

  describe "the organization's terms-of-service version" do
    let!(:static_page) { Decidim::StaticPage.find_by(slug: "terms-of-service", organization:) }

    let(:form_params) do
      {
        static_page: {
          id: static_page.id,
          slug: static_page.slug,
          title: { en: "Updated title" },
          content: { en: "<p>Updated content</p>" },
          weight: static_page.weight,
          allow_public_access: static_page.allow_public_access,
          changed_notably:,
          add_documents: uploaded_documents
        }
      }
    end

    let(:command) do
      described_class.new(form, static_page)
    end

    context "when changed_notably is checked" do
      let(:changed_notably) { true }

      it "updates the organization's tos_version" do
        expect { command.call }.to(change { organization.reload.tos_version })
      end
    end

    context "when changed_notably is not checked" do
      let(:changed_notably) { false }

      it "does not update the organization's tos_version" do
        expect { command.call }.not_to(change { organization.reload.tos_version })
      end
    end
  end
end
