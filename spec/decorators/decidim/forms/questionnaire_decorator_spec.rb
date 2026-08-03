# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

describe Decidim::Forms::Questionnaire do
  describe "#organization" do
    let(:questionable) { create(:dummy_resource) }
    let(:questionnaire) { create(:questionnaire, questionnaire_for: questionable) }

    it "delegates to the questionnaire_for organization" do
      expect(questionnaire.organization).to eq(questionable.organization)
    end
  end

  describe "automatic translations" do
    let(:questionable) { create(:dummy_resource) }
    let(:questionnaire) { create(:questionnaire, questionnaire_for: questionable) }

    it "updates the stored translated text when a new translation is saved" do
      questionnaire.update!(
        title: questionnaire.title.merge(
          "machine_translations" => {
            "en" => "en - Títol inicial"
          }
        )
      )

      Decidim::MachineTranslationSaveJob.perform_now(
        questionnaire,
        "title",
        "en",
        "en - Títol actualitzat"
      )

      expect(questionnaire.reload.title.dig("machine_translations", "en")).to eq("en - Títol actualitzat")
    end
  end
end