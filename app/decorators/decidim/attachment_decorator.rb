# frozen_string_literal: true

module Decidim::AttachmentDecorator
  def self.decorate
    Decidim::Attachment.include(PdfSecurity::AttachmentValidation)
  end
end

Decidim::AttachmentDecorator.decorate
