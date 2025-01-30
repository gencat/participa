# frozen_string_literal: true

module Decidim::Pages::ApplicationControllerDecorator
  def self.decorate
    Decidim::Pages::ApplicationController.class_eval do
      include ::Decidim::AttachmentsHelper

      helper_method :tab_panel_items

      private

      def tab_panel_items
        @tab_panel_items ||= attachments_tab_panel_items(@page)
      end
    end
  end
end

::Decidim::Pages::ApplicationControllerDecorator.decorate
