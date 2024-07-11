# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when creating a static scope.
    class CreateType < Decidim::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form)
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

        create_department
        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_department
        ::DecidimType.create!(
          name: form.name,
          decidim_organization_id: current_organization.id
        )
      end

      def type_exists
        @type_exists ||= ::DecidimType.exists?(name: form.name, decidim_organization_id: current_organization.id)
      end
    end
  end
end
