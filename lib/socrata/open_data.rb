# frozen_string_literal: true

module Socrata
  class OpenData
    class << self
      def log(string)
        puts string
        logger.info("\n#{string}\n")
      end

      def log_error(string)
        puts string
        logger.error("\n#{string}\n")
      end

      private

      def logger
        @logger ||= Logger.new("#{Rails.root}/log/socrata.log")
      end

      def collection
        Decidim::ParticipatoryProcess.where(
          organization: Decidim::Organization.first
        )
      end

      def serializer
        Decidim::ParticipatoryProcesses::ParticipatoryProcessSerializer
      end
    end
  end
end
