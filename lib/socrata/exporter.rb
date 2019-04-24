# frozen_string_literal: true

module Socrata
  class Exporter < OpenData
    class << self
      # Returns both the file name (with timestamp) and the exported data as a String.
      def export(format)
        log('Exporting dataset...')

        file_format = format || default_format
        export_data = Decidim::Exporters.find_exporter(file_format).new(collection, serializer).export
        file_name = export_data.filename(default_name)

        log("File created: #{file_name}")

        [file_name, export_data.read]
      rescue StandardError => error
        log_error(error)
      end

      private

      def default_format
        'CSV'
      end

      def default_name
        'socrata_open_data'
      end
    end
  end
end
