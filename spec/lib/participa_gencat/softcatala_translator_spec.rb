# frozen_string_literal: true

require "rails_helper"

module ParticipaGencat
  describe SoftcatalaTranslator do
    subject { described_class.new(resource, field_name, original_value, target_locale, source_locale) }

    let(:resource) { create(:participatory_process, title: { source_locale => original_value }) }
    let(:source_locale) { :en }
    let(:target_locale) { :ca }
    let(:field_name) { :title }
    let(:original_value) { "My title" }
    let(:text_to_translate) { original_value }
    let(:translated_value) { "El meu títol" }

    let(:softcatala_client) { SoftcatalaClient.new }

    before do
      expect(SoftcatalaClient).to receive(:new).and_return(softcatala_client)
      expect(softcatala_client).to receive(:translate).with(text_to_translate, :en, :ca).and_return(translated_value)
    end

    it "delegates the translation to the softcatala_client" do
      subject.translate
    end

    it "schedules a job to save the attribute" do
      expect(::Decidim::MachineTranslationSaveJob)
        .to receive(:perform_later)
        .with(
          resource,
          field_name,
          target_locale,
          translated_value
        )

      subject.translate
    end

    context "when there is HTML in the original text" do
      let(:original_value) { "<h1>My title</h1>" }
      let(:text_to_translate) { "My title" }

      it "removes the HTML before sending the text to the client" do
        subject.translate
      end
    end

    context "when the translation fails" do
      let(:translated_value) { nil }

      it "schedules a job to save an empty string" do
        expect(::Decidim::MachineTranslationSaveJob)
          .to receive(:perform_later)
          .with(
            resource,
            field_name,
            target_locale,
            ""
          )

        subject.translate
      end
    end
  end
end
