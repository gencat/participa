# frozen_string_literal: true

module Socrata
  class OpenData
    class << self
      def logger
        @logger ||= Logger.new("#{Rails.root}/log/socrata.log")
      end

      def log(string)
        puts string
        logger.info("\n#{string}\n")
      end
    end
  end
end
