# frozen_string_literal: true

Decidim::Meetings::Admin::MeetingForm.class_eval do
    def map_model(model)
        self.services = model.services.map do |service|
            MeetingServiceForm.new(service)
        end

        self.decidim_category_id = model.categorization.decidim_category_id if model.categorization
        self.start_time = model.start_time.strftime('%d/%m/%Y %H:%M') if model.start_time.present?
        self.end_time = model.end_time.strftime('%d/%m/%Y %H:%M') if model.end_time.present?
        presenter = Decidim::Meetings::MeetingPresenter.new(model)
        self.title = presenter.title(all_locales: true)
        self.description = presenter.description(all_locales: true)
    end
end
  