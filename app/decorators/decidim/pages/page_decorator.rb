# frozen_string_literal: true

module Decidim::Pages::PageDecorator
  def self.decorate
    Decidim::Pages::Page.class_eval do
      include Decidim::HasAttachments
    end
  end
end

Decidim::Pages::PageDecorator.decorate
