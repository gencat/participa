# frozen_string_literal: true

module Decidim::Pages::Admin::PagesControllerDecorator
  def self.decorate
    Decidim::Pages::Admin::PagesController.class_eval do
      helper_method :tab_panel_items
    end
  end
end

::Decidim::Pages::Admin::PagesControllerDecorator.decorate
