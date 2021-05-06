# frozen_string_literal: true

namespace :open_data do
  namespace :participatory_processes do
    desc "Generates a CSV file with the partipatory_processes open data."
    task export: :environment do
      OpenData.export(collection, serializer)
    end

    desc "Updates the Socrata dataset via HTTP POST request"
    task publish_to_socrata: :environment do
      OpenData.publish_to_socrata(collection, serializer)
    end

    # ParticipatoryProcesses that are published AND not private.
    def collection
      Decidim::ParticipatoryProcess
        .where(organization: Decidim::Organization.first)
        .published.public_spaces
    end

    # Class used to transform ParticipatoryProcesses into data.
    def serializer
      Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer
    end
  end
end
