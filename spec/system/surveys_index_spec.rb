# frozen_string_literal: true

require "rails_helper"

describe "Surveys index page", type: :system do
  let!(:organization) { create(:organization) }
  let!(:participatory_process) { create(:participatory_process, :published, :with_steps, organization:) }
  let!(:component) { create(:surveys_component, :published, participatory_space: participatory_process) }
  let(:router) { Decidim::EngineRouter.main_proxy(component) }

  before do
    switch_to_host(organization.host)
  end

  context "when there is only one published survey" do
    let!(:survey) { create(:survey, :published, component:) }
    let!(:unpublished_survey) { create(:survey, component:, published_at: nil) }

    it "redirects to the survey page" do
      visit router.surveys_path

      expect(page).to have_current_path(router.survey_path(survey), ignore_query: true)
    end

    it "redirects when accessing from the component root" do
      visit router.root_path

      expect(page).to have_current_path(router.survey_path(survey), ignore_query: true)
    end
  end

  context "when there are several published surveys" do
    let!(:surveys) { create_list(:survey, 2, :published, :allow_answers, component:) }

    it "lists them" do
      visit router.surveys_path

      expect(page).to have_current_path(router.surveys_path, ignore_query: true)
      surveys.each do |survey|
        expect(page).to have_link(href: router.survey_path(survey))
      end
    end
  end
end
