# frozen_string_literal: true

module Decidim::Admin::StaticPageFormDecorator
  def self.decorate
    Decidim::Admin::StaticPageForm.class_eval do
      include Decidim::AttachmentAttributes
      include Decidim::HasUploadValidations

      attribute :attachment, ::Decidim::Admin::AttachmentForm

      validate :notify_missing_attachment_if_errored

      def map_model(model)
        super(model)
        self.attachment = if model.documents.first.present?
                            { file: model.documents.first.file, title: translated_attribute(model.documents.first.title) }
                          else
                            {}
                          end
      end

      private

      # This method will add an error to the `attachment` field only if there is
      # any error in any other field. This is needed because when the form has
      # an error, the attachment is lost, so we need a way to inform the user of
      # this problem.
      def notify_missing_attachment_if_errored
        errors.add(:attachment, :needs_to_be_reattached) if errors.any? && attachment.present?
      end
      
    end
  end
end

::Decidim::Admin::StaticPageFormDecorator.decorate
