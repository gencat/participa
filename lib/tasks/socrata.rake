# frozen_string_literal: true

namespace :socrata do
  desc 'Generates a file with the organization processes open data.'
  # Can be called with the following arguments:
  # - format - The exporter format as a string. Defaults to "CSV"
  # - i.e. rake socrata:export["JSON"]
  task :export, [:format] => :environment do |_task, args|
    Socrata::Log.log('Exporting dataset...')

    file_name, export_data = Socrata::Exporter.export(args.format)
    File.write(file_name, export_data)

    Socrata::Log.log("File created: #{file_name}")
  end

  desc 'Updates Socrata dataset via POST method with soda-ruby'
  # Returns a Hashie::Mash that represents the body of the response.
  task :publish, [:file] => :environment do |_task, _args|
    Socrata::Log.log('Pushing data to soda.demo.socrata.com...')

    response = Socrata::Publisher.publish

    Socrata::Log.log(response)
  end
end
