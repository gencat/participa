# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when updating a scope.
    class UpdateDepartment < Rectify::Command
      # Public: Initializes the command.
      #
      # scope - The Scope to update
      # form - A form object with the params.
      def initialize(department, form)
        @department = department
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

        update_department
        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_department
        @department.update_attributes!(attributes)
      end

      def attributes
        {
          name: form.name
        }
      end

      def department_exists
        @department_exists ||= ::DecidimDepartment.exists?(:name => form.name, decidim_organization_id: current_organization.id)
      end

    end
  end
end
