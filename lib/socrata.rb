# frozen_string_literal: true

require 'soda/client'

# This module holds the logic used in lib/tasks/socrata.rake
module Socrata
  class << self
    # Returns both the file name (with timestamp) and the exported data as a String.
    def export(format)
      log(:info, 'Exporting dataset...')

      file_format = format || 'CSV'
      export_data = Decidim::Exporters.find_exporter(file_format).new(collection, serializer).export
      file_name = export_data.filename('socrata_open_data')

      log(:info, "File created: #{file_name}")

      [file_name, export_data.read]
    rescue StandardError => error
      log(:error, error)
    end

    # Returns a Hashie::Mash that represents the body of the HTTP response.
    def publish
      log(:info, 'Pushing data to Socrata...')

      client = SODA::Client.new(credentials)
      payload = collection.map { |resource| serializer.new(resource).serialize.compact }
      response = client.post(ENV['SODA_DATASET_IDENTIFIER'], payload)

      log(:info, response.body)
    rescue StandardError => error
      log(:error, error)
    end

    private

    def log(level, message)
      @logger ||= Logger.new("#{Rails.root}/log/socrata.log")
      @logger.send(level, message)
      puts message
    end

    def collection
      Decidim::ParticipatoryProcess.where(organization: Decidim::Organization.first)
    end

    def serializer
      Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer
    end

    def credentials
      {
        domain: ENV['SODA_DOMAIN'],
        username: ENV['SODA_USERNAME'],
        password: ENV['SODA_PASSWORD'],
        app_token: ENV['SODA_APP_TOKEN']
      }
    end
  end
end
