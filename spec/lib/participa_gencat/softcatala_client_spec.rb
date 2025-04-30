# frozen_string_literal: true

require "rails_helper"

module ParticipaGencat
  describe SoftcatalaClient do
    subject { described_class.new }

    let(:original_value) { "My title" }
    let(:source_locale) { :en }
    let(:target_locale) { :ca }
    let(:translated_value) { "El meu títol" }
    let(:response) do
      %({"responseData": {"translatedText": "#{translated_value}"}})
    end

    before do
      stub_request(:post, "https://softcatala.example.org/machine_translations/endpoint")
        .with(
          body: { "langpair"=>"en|cat", "markUnknown"=>"y", "q"=>"My title" },
          headers: {
            "Accept" => "application/json, text/javascript, */*; q=0.01",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Accept-Language" => "ca,en-US;q=0.7,en;q=0.3",
            "Cache-Control" => "no-cache",
            "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
            "Host" => "softcatala.example.org",
            "Pragma" => "no-cache",
            "User-Agent" => "ParticipaGencat.cat"
          }
        )
        .to_return(status: 200, body: response, headers: {})
    end

    it "invokes the SoftCatalà web site" do
      translation= subject.translate(original_value, source_locale, target_locale)
      expect(translation).to eq(translated_value)
    end
  end
end
