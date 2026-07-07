# frozen_string_literal: true

module Decidim::Admin::StaticPagesControllerDecorator
  def self.decorate
    Decidim::Admin::StaticPagesController.class_eval do
      helper_method :tab_panel_items
    end
  end
end

Decidim::Admin::StaticPagesControllerDecorator.decorate
