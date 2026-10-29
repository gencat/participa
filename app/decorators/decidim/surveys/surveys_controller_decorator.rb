# frozen_string_literal: true

module Decidim::Surveys::SurveysControllerDecorator
  def self.decorate
    Decidim::Surveys::SurveysController.class_eval do
      before_action :redirect_to_single_survey, only: [:index]

      private

      # Skip the index when the component has only one published survey,
      # so browsing from the participatory space goes straight to it.
      def redirect_to_single_survey
        return unless request.format.html?

        published_surveys = search_collection.published
        return unless published_surveys.one?

        redirect_to survey_path(published_surveys.first)
      end
    end
  end
end

Decidim::Surveys::SurveysControllerDecorator.decorate
