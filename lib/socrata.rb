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
      File.write(file_name, export_data)

      log(:info, "File created: #{file_name}")
    rescue StandardError => error
      log(:error, error)
    end

    # Updates the remote Socrata dataset.
    # Logs and Outputs the HTTP responses.
    # Returns nothing.
    def publish
      log(:info, 'Pushing data to Socrata...')

      update_response = client.post(database_identifier, update_payload)
      delete_response = client.post(database_identifier, delete_payload)

      log(:info, "Update response: #{update_response.body}")
      log(:info, "Update response: #{delete_response.body}")
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
    def public_processes
      collection.published.public_spaces
    end

    # ParticipatoryProcesses that are unpublished OR private.
    def private_processes
      collection.unpublished.or(collection.private_spaces)
    end

    # ParticipatoryProcesses of the organization.
    def collection
      @collection ||= Decidim::ParticipatoryProcess.where(
        organization: Decidim::Organization.first
      )
    end

    # Class used to transform ParticipatoryProcesses into data.
    def serializer
      Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer
    end

    # Returns a SODA::Client instance.
    # https://www.rubydoc.info/github/socrata/soda-ruby/SODA/Client
    def client
      @client ||= SODA::Client.new(
        domain: ENV['SODA_DOMAIN'],
        username: ENV['SODA_USERNAME'],
        password: ENV['SODA_PASSWORD'],
        app_token: ENV['SODA_APP_TOKEN']
      )
    end

    # Identifier for the dataset we want to access, as in:
    # https://soda.demo.socrata.com/dataset/Example-Dataset/identifier
    def database_identifier
      ENV['SODA_DATASET_IDENTIFIER']
    end

    # Payload to CREATE new rows and to UPDATE existing ones.
    # Does not accept null values, so we remove them with Hash.compact().
    def update_payload
      public_processes.map do |process|
        serializer.new(process).serialize.compact
      end
    end

    # Payload to DELETE data of processes that are no longer public.
    # Check existing rows first, as only rows that can be found can be deleted.
    def delete_payload
      ids = client.get(database_identifier, '$select' => 'id').body.pluck(:id)
      private_processes.pluck(:id).each_with_object([]) do |id, arr|
        next unless ids.include?(id.to_s)

        arr << { 'id' => id, ':deleted' => true }
      end
    end
  end
end
