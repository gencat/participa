# frozen_string_literal: true

require 'soda/client'

module Socrata
  class Publisher
    class << self
      # Returns a Hashie::Mash that represents the body of the response.
      def publish
        client.post(identifier, data)
      end

      private

      # Identifier for the dataset we want to access, i.e.
      # https://soda.demo.socrata.com/dataset/Example-dataset/identifier
      def identifier
        'identifier'
      end

      # https://www.rubydoc.info/github/socrata/soda-ruby/SODA/Client
      def client
        SODA::Client.new(
          domain: ENV['SODA_DOMAIN'],
          username: ENV['SODA_USERNAME'],
          password: ENV['SODA_PASSWORD'],
          app_token: ENV['SODA_APP_TOKEN']
        )
      end

      # The soda-ruby post method accepts both JSON and CSV
      # http://socrata.github.io/soda-ruby/examples/upsert.html
      def data
        Socrata::Exporter.export('JSON').second
      end
    end
  end
end
