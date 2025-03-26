# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcessDecorator
  def attributes
    super.merge({
                  cost: form.cost,
                  has_summary_record: form.has_summary_record,
                  promoting_unit: form.promoting_unit,
                  facilitators: form.facilitators,
                  email: form.email
                })
  end

  private :attributes
end

Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcess.prepend(Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcessDecorator)
