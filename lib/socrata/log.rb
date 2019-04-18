# frozen_string_literal: true

module Socrata
  class Log
    class << self
      def log(string)
        puts string
        logger.info("\n#{string}\n")
      end

      private

      def logger
        @logger ||= Logger.new("#{Rails.root}/log/socrata.log")
      end
    end
  end
end
