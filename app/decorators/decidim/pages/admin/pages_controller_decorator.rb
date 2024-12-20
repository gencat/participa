# frozen_string_literal: true

module Decidim::Pages::Admin::PagesControllerDecorator
  def self.decorate
    Decidim::Pages::Admin::PagesController.class_eval do
      helper_method :tab_panel_items

      def edit
        enforce_permission_to(:update, :page)
        @form = form(::Decidim::Pages::Admin::PageForm).from_model(page)
      end
    end
  end
end

::Decidim::Pages::Admin::PagesControllerDecorator.decorate
