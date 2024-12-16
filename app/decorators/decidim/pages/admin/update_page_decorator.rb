# frozen_string_literal: true

module Decidim::Pages::Admin::UpdatePageDecorator
  def self.decorate
    Decidim::Pages::Admin::UpdatePage.class_eval do
      include ::Decidim::AttachmentMethods
            
      def initialize(form, page)
        @form = form
        @page = page
        @attached_to = page
      end

      def call
        return broadcast(:invalid) if @form.invalid?
        
        if process_attachments?
          @page.attachments.destroy_all

          build_attachment
          return broadcast(:invalid) if attachment_invalid?
        end

        transaction do
          update_page
          create_attachment if process_attachments?
          broadcast(:ok)
        end
      end
      
      def update_page
        parsed_body = Decidim::ContentProcessor.parse(form.body, current_organization: form.current_organization).rewrite
        Decidim.traceability.update!(
          page,
          form.current_user,
          body: parsed_body
        )
      end
      
      
      private

      attr_reader :form, :page, :current_user, :attachment
      
      def process_attachments?
        attachment_present? && attachment_file_uploaded?
      end

      def attachment_present?
        @form.attachment.file.present?
      end

      def attachment_file_uploaded?
        !@form.attachment.file.is_a?(::Decidim::ApplicationUploader)
      end

    end
  end
end

::Decidim::Pages::Admin::UpdatePageDecorator.decorate
