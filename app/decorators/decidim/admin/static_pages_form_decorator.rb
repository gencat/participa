# frozen_string_literal: true

module Decidim::Admin::StaticPagesFormDecorator
  def self.decorate
    Decidim::Admin::StaticPageForm.class_eval do
      include Decidim::AttachmentAttributes
      include Decidim::HasUploadValidations

      attribute :attachment, ::Decidim::AttachmentForm

      attachments_attribute :attachments

      def map_model(model)
        self.attachments = model.attachments
      end
    end
  end
end

Decidim::Admin::StaticPagesFormDecorator.decorate
