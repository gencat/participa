# frozen_string_literal: true

module Decidim::StaticPageDecorator
  def self.decorate
    Decidim::StaticPage.class_eval do
      include Decidim::HasAttachments
    end
  end
end

::Decidim::StaticPageDecorator.decorate
