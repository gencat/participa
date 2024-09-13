# frozen_string_literal: true

# Add custom participa fields to ParticipatoryProcess serializer
module Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializerDecorator
  def serialize
    attributes = super
    attributes.merge({
                       cost: participatory_process.cost,
                       has_record: participatory_process.has_summary_record?,
                       facilitators: participatory_process.facilitators,
                       promoting_unit: participatory_process.promoting_unit,
                       email: participatory_process.email
                     })
  end

  private :serialize
end

::Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer.prepend(Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializerDecorator)
