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
                       email: resource.email,
                       twitter_handler: resource.twitter_handler,
                       facebook_handler: resource.facebook_handler,
                       instagram_handler: resource.instagram_handler,
                       youtube_handler: resource.youtube_handler,
                       github_handler: resource.github_handler
                     })
  end
end

Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer.prepend(Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializerDecorator)
