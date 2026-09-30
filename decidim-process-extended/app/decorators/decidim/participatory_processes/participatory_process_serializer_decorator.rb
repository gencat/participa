# frozen_string_literal: true

# Add custom participa fields to ParticipatoryProcess serializer
module Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializerDecorator
  def serialize
    attributes = super
    attributes.merge({
                       cost: resource.cost,
                       has_record: resource.has_summary_record?,
                       facilitators: resource.facilitators,
                       promoting_unit: resource.promoting_unit,
                       email: resource.email
                     })
  end
end

Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer.prepend(Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializerDecorator)
