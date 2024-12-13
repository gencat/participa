# frozen_string_literal: true

module Decidim::Pages::Admin::PageFormDecorator
  def self.decorate
    Decidim::Pages::Admin::PageForm.class_eval do
      include Decidim::AttachmentAttributes
      include Decidim::HasUploadValidations
      
      attribute :attachment, ::Decidim::AttachmentForm
      attachments_attribute :documents
      
      def map_model(model)
        super(model)
        self.attachment = if model.documents.first.present?
                            { file: model.documents.first.file, title: translated_attribute(model.documents.first.title) }
                          else
                            {}
                          end
      end
      
    end
  end
end

::Decidim::Pages::Admin::PageFormDecorator.decorate
