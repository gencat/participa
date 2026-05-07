# frozen_string_literal: true

module Decidim::PagesControllerDecorator
  def self.decorate
    Decidim::PagesController.class_eval do
      include ::Decidim::AttachmentsHelper

      helper_method :tab_panel_items

      private

      def tab_panel_items
        @tab_panel_items ||= attachments_tab_panel_items(@page)
      end
    end
  end
end

::Decidim::PagesControllerDecorator.decorate
