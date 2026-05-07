# frozen_string_literal: true

module Decidim::StaticPagesDecorator
  def self.decorate
    Decidim::StaticPage.class_eval do
      include Decidim::HasAttachments
    end
  end
end

::Decidim::StaticPagesDecorator.decorate