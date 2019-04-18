# frozen_string_literal: true

module Socrata
  class Exporter
    class << self
      # Returns the file name and the data as a String.
      def export(format)
        file_format = format || default_format

        export_data = Decidim::Exporters.find_exporter(file_format).new(collection, serializer).export
        file_name = export_data.filename(default_name)

        [file_name, export_data.read]
      end

      private

      def default_format
        'CSV'
      end

      def default_name
        'socrata_open_data'
      end

      def collection
        Decidim::ParticipatoryProcess.where(
          organization: Decidim::Organization.first
        )
      end

      def serializer
        Decidim::Process::Extended::ProcessSerializer
      end
    end
  end
end
