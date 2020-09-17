# frozen_string_literal: true

Decidim::Debates::Admin::DebateForm.class_eval do
  def map_model(model)
    self.decidim_category_id = model.category.try(:id)
    self.start_time = model.start_time.strftime('%d/%m/%Y %H:%M') if model.start_time.present?
    self.end_time = model.end_time.strftime('%d/%m/%Y %H:%M') if model.end_time.present?
  end
end
