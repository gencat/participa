# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

describe Decidim::Admin::CreateStaticPage do
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

  describe "call" do
    let(:form_params) do
      {
        static_page: {
          slug: "new-page",
          title: { en: "New page" },
          content: { en: "<p>New content</p>" },
          weight: 1,
          allow_public_access: true,
          add_documents: uploaded_documents
        }
      }
    end

    let(:command) { described_class.new(form) }

    before { command }

    describe "when the form is not valid" do
      before do
        allow(form).to receive(:invalid?).and_return(true)
      end

      it "broadcast invalid" do
        expect { command.call }.to broadcast(:invalid)
      end

      it "does not create a static page" do
        expect { command.call }.not_to change(Decidim::StaticPage, :count)
      end
    end

    describe "when the form is valid" do
      it "broadcast ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "creates the static page" do
        expect { command.call }.to change(Decidim::StaticPage, :count).by(1)
      end

      it "sets the static page attributes" do
        command.call
        page = Decidim::StaticPage.find_by(slug: "new-page")

        expect(page.slug).to eq("new-page")
        expect(page.title["en"]).to eq("New page")
        expect(page.weight).to eq(1)
        expect(page.allow_public_access).to be(true)
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
          expect(last_attachment.attached_to).to eq(Decidim::StaticPage.find_by(slug: "new-page"))
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

        it "does not create the static page" do
          expect { command.call }.not_to change(Decidim::StaticPage, :count)
        end

        it "does not create the attachment" do
          expect { command.call }.not_to change(Decidim::Attachment, :count)
        end
      end
    end
  end

  describe "the organization's terms-of-service version" do
    let(:organization) { create(:organization, create_static_pages: false) }
    let(:form_params) do
      {
        static_page: {
          slug: "terms-of-service",
          title: { en: "Terms of service" },
          content: { en: "<p>Terms</p>" },
          weight: 1,
          allow_public_access: true,
          add_documents: uploaded_documents
        }
      }
    end

    let(:command) { described_class.new(form) }

    it "sets the organization's tos_version" do
      expect { command.call }.to(change { organization.reload.tos_version })
    end
  end
end
