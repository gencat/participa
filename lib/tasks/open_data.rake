# frozen_string_literal: true

namespace :open_data do
  namespace :export do
    desc 'Generates a file with the organization processes open data.'
    # Can be called with the following arguments:
    # - format - The exporter format as a string. Defaults to "CSV"
    # - i.e. rake socrata:export["JSON"]
    task :participatory_processess, [:format] => :environment do |_task, args|
      collection = Decidim::ParticipatoryProcess.where(
        organization: Decidim::Organization.first
      ).published.public_spaces
      Socrata.export(args[:format], collection)
    end
  end

  namespace :publish_to_socrata do
    desc 'Updates the Socrata dataset via HTTP POST request'
    # The response object will be a summary of the updates that were made
    # and possibly the errors that were encountered.
    task participatory_processess: :environment do
      collection = Decidim::ParticipatoryProcess.where(
        organization: Decidim::Organization.first
      ).published.public_spaces
      Socrata.publish(collection)
    end
  end
end
