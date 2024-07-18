# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.class_eval do
  alias_method :original_attributes, :attributes

  def attributes
    original_attributes.merge({
      cost: form.cost,
      has_summary_record: form.has_summary_record,
      promoting_unit: form.promoting_unit,
      facilitators: form.facilitators,
      email: form.email,
      decidim_type: form.type
    })
  end
end
