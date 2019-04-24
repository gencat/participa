# frozen_string_literal: true

require 'soda/client'

module Socrata
  class Publisher < OpenData
    class << self
      # Returns a Hashie::Mash that represents the body of the response.
      def publish
        log("Pushing data to #{ENV['SODA_DOMAIN']}...")

        response = client.post(dataset_identifier, payload)

        log(response.body)
      rescue StandardError => error
        log_error(error)
      end

      private

      # Returns a SODA::Client instance.
      # https://www.rubydoc.info/github/socrata/soda-ruby/SODA/Client
      # Source code:
      # https://github.com/socrata/soda-ruby/blob/master/lib/soda/client.rb
      def client
        SODA::Client.new(
          domain: ENV['SODA_DOMAIN'],
          username: ENV['SODA_USERNAME'],
          password: ENV['SODA_PASSWORD'],
          app_token: ENV['SODA_APP_TOKEN']
        )
      end

      # Identifier for the dataset we want to access, i.e.:
      # https://soda.demo.socrata.com/dataset/Example-Dataset/identifier
      def dataset_identifier
        ENV['SODA_DATASET_IDENTIFIER']
      end

      # Payload to POST. Will be converted to JSON.
      # http://socrata.github.io/soda-ruby/examples/upsert.html
      # Does not accept nil values, so we discard them with Hash.compact().
      def payload
        collection.map { |resource| serializer.new(resource).serialize.compact }
      end
    end
  end
end
