# frozen_string_literal: true

module Decidim::Pages::Admin::PageFormDecorator
  def self.decorate
    Decidim::Pages::Admin::PageForm.class_eval do
      include Decidim::AttachmentAttributes
      include Decidim::HasUploadValidations

      attribute :attachment, ::Decidim::AttachmentForm

      attachments_attribute :documents

      def map_model(model)
        self.documents = model.attachments
      end
    end
  end
end

Decidim::Pages::Admin::PageFormDecorator.decorate
