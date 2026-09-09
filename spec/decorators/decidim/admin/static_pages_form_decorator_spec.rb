# frozen_string_literal: true

require "rails_helper"

describe Decidim::Admin::StaticPagesFormDecorator do
  subject do
    Decidim::Admin::StaticPageForm.from_params(attributes).with_context(
      current_organization:
    )
  end

  let(:current_organization) { create(:organization) }
  let(:attachment_params) { nil }

  let(:content) do
    {
      en: "<p>Content</p>",
      ca: "<p>Contingut</p>",
      es: "<p>Contenido</p>"
    }
  end

  let(:attributes) do
    {
      static_page: {
        slug: "help",
        title: { en: "Help", ca: "Ajuda", es: "Ayuda" },
        content:,
        attachment: attachment_params
      }
    }
  end

  context "when everything is OK" do
    it { is_expected.to be_valid }
  end

  describe "attachment attributes added by decorator" do
    it "responds to documents" do
      expect(subject).to respond_to(:documents)
    end

    it "responds to add_documents" do
      expect(subject).to respond_to(:add_documents)
    end

    it "responds to attachment" do
      expect(subject).to respond_to(:attachment)
    end
  end

  describe "map_model" do
    let(:static_page) { create(:static_page, organization: current_organization) }

    let(:mapped_form) do
      Decidim::Admin::StaticPageForm.from_model(static_page).with_context(
        current_organization:
      )
    end

    context "when the page has a document attachment" do
      let!(:document) { create(:attachment, :with_pdf, attached_to: static_page) }

      it "includes it in documents" do
        expect(mapped_form.documents).to include(document)
      end
    end

    context "when the page has an image attachment" do
      let!(:photo) { create(:attachment, :with_image, attached_to: static_page) }

      it "includes it in documents" do
        expect(mapped_form.documents).to include(photo)
      end
    end
  end
end
