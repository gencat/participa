# frozen_string_literal: true

require "rails_helper"

describe Decidim::Admin::StaticPageForm do
  subject do
    described_class.from_params(attributes).with_context(
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

    it "responds to photos" do
      expect(subject).to respond_to(:photos)
    end

    it "responds to add_photos" do
      expect(subject).to respond_to(:add_photos)
    end

    it "responds to attachment" do
      expect(subject).to respond_to(:attachment)
    end
  end
end
