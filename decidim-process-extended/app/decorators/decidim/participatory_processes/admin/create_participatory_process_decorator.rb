# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
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

::Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.prepend(Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator)
