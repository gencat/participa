# frozen_string_literal: true

require "rails_helper"
# require "participa_gencat/softcatala_translator"

module ParticipaGencat
  describe SoftcatalaClient do
    subject { described_class.new }

    let(:original_value) { "My title" }
    let(:source_locale) { :en }
    let(:target_locale) { :ca }
    let(:translated_value) { "El meu títol" }

    before do
      expect(SoftcatalaClient).to receive(:new).and_return(softcatala_client)
      expect(softcatala_client).to receive(:translate).with(original_value, :en, :ca).and_return(translated_value)
    end

    it "invokes the softcatala" do
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
  end
end
