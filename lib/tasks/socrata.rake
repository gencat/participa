# frozen_string_literal: true

namespace :socrata do
  desc 'Generates a file with the organization processes open data.'
  # Can be called with the following arguments:
  # - format - The exporter format as a string. Defaults to "CSV"
  # - i.e. rake socrata:export["JSON"]
  task :export, [:format] => :environment do |_task, args|
    file_name, export_data = Socrata.export(args.format)
    File.write(file_name, export_data)
  end

  desc 'Updates the Socrata dataset via HTTP POST request'
  # The response object will be a summary of the updates that were made
  # and possibly the errors that were encountered.
  task publish: :environment do
    Socrata.publish
  end
end
