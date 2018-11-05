# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when creating a static scope.
    class CreateDepartment < Rectify::Command
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
        return broadcast(:exists) if department_exists
        return broadcast(:invalid) if form.invalid?
        create_department
        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_department
        ::DecidimDepartment.create!(
          name: form.name,
          decidim_organization_id: current_organization.id
        )
      end

      def department_exists
        @department_exists ||= ::DecidimDepartment.exists?(:name => form.name, decidim_organization_id: current_organization.id)
      end
    end
  end
end
