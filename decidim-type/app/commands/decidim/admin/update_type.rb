# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when updating a scope.
    class UpdateType < Rectify::Command
      # Public: Initializes the command.
      #
      # scope - The Scope to update
      # form - A form object with the params.
      def initialize(type, form)
        @type = type
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:exists) if type_exists
        return broadcast(:invalid) if form.invalid?

        update_type
        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_type
        @type.update_attributes!(attributes)
      end

      def attributes
        {
          name: form.name
        }
      end

      def type_exists
        @type_exists ||= ::DecidimType.exists?(:name => form.name, decidim_organization_id: current_organization.id)
      end
    end
  end
end
