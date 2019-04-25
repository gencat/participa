# frozen_string_literal: true

require 'soda/client'

# This module holds the logic used in lib/tasks/socrata.rake
module Socrata
  class << self
    # Creates a file in the current directory.
    # Logs and Outputs the name of the file (timestamped).
    # Returns nothing.
    def export(file_format)
      log(:info, 'Exporting dataset...')

      exporter = Decidim::Exporters.find_exporter(file_format || 'CSV')
      export_data = exporter.new(public_processes, serializer).export
      file_name = export_data.filename('socrata_open_data')
      File.write(file_name, export_data.read)

      log(:info, "File created: #{file_name}")
    rescue StandardError => error
      log(:error, error)
    end

    # Updates the remote Socrata dataset.
    # Logs and Outputs the HTTP response.
    # Returns nothing.
    def publish
      log(:info, 'Pushing data to Socrata...')

      response = client.post(dataset_identifier, payload)

      log(:info, response.body)
    rescue StandardError => error
      log(:error, error)
    end

    private

    # Logs to a custom file.
    def log(level, message)
      @logger ||= Logger.new("#{Rails.root}/log/socrata.log")
      @logger.send(level, message)
      puts message
    end

    # ParticipatoryProcesses that are published AND not private.
    def collection
      Decidim::ParticipatoryProcess.where(
        organization: Decidim::Organization.first
      ).published.public_spaces
    end

    # Class used to transform ParticipatoryProcesses into data.
    def serializer
      Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer
    end

    # Returns a SODA::Client instance. Needs to be authenticated.
    # https://www.rubydoc.info/github/socrata/soda-ruby/SODA/Client
    def client
      @client ||= SODA::Client.new(Rails.application.secrets.soda)
    end

    # Identifier for the dataset we want to access, as in:
    # https://soda.demo.socrata.com/dataset/Example-Dataset/identifier
    def dataset_identifier
      Rails.application.secrets.soda[:dataset_identifier]
    end

    # Payload body of the HTTP POST Request
    # Does not accept null values, so we remove them with Hash.compact().
    def payload
      collection.map { |process| serializer.new(process).serialize.compact }
    end
  end
end
