# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when updating a scope.
    class UpdateTheme < Rectify::Command
      # Public: Initializes the command.
      #
      # scope - The Scope to update
      # form - A form object with the params.
      def initialize(theme, form)
        @theme = theme
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:exists) if theme_exists
        return broadcast(:invalid) if form.invalid?

        update_theme
        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_theme
        @theme.update_attributes!(attributes)
      end

      def attributes
        {
          name: form.name
        }
      end

      def theme_exists
        @theme_exists ||= DecidimTheme.exists?(:name => form.name, decidim_organization_id: current_organization.id)
      end
    end
  end
end
