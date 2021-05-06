# frozen_string_literal: true

require "soda/client"

# This module holds the logic used in lib/tasks/open_data/*.rake
module OpenData
  class << self
    # Public: creates a CSV file in the current directory.
    #
    # collection  - The collection of objects to extract the data from.
    # serializer  - The class used to transform the collection into data.
    #
    # Logs and Outputs the name of the file (timestamped).
    def export(collection, serializer)
      log(:info, "Exporting dataset...")

      exporter = Decidim::Exporters::CSV
      export_data = exporter.new(collection, serializer).export
      file_name = export_data.filename(collection.first.model_name.plural)
      File.write(file_name, export_data.read)

      log(:info, "File created: #{file_name}")
    rescue StandardError => e
      log(:error, e)
    end

    # Public: increments the remote Socrata dataset.
    #
    # collection - The collection of objects to extract the data from.
    # serializer - The class used to transform the collection into data.
    #
    # Logs and Outputs the HTTP response.
    def publish_to_socrata(collection, serializer)
      log(:info, "Pushing data to Socrata...")

      client = SODA::Client.new(Rails.application.secrets.soda)
      identifier = Rails.application.secrets.soda[:dataset_identifier]
      payload = serialize_in_batches(collection, serializer)
      response = client.post(identifier, payload)

      log(:info, response.body)
    rescue StandardError => e
      log(:error, e)
    end

    private

    # Logs to a custom file.
    def log(level, message)
      @logger ||= Logger.new(Rails.root.join("log", "open_data.log"))
      @logger.send(level, message)
      puts message
    end

    # Serializes the collection in batches to avoid server memory problems.
    # Keep in mind the body of the HTTP POST Request doesn't accept null values.
    def serialize_in_batches(collection, serializer)
      collection.find_in_batches(batch_size: 50).each_with_object([]) do |batch, arr|
        arr << batch.map { |resource| serializer.new(resource).serialize.compact }
      end.flatten
    end
  end
end
