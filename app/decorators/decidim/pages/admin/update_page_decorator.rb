# frozen_string_literal: true

module Decidim::Pages::Admin::UpdatePageDecorator
  def self.decorate
    Decidim::Pages::Admin::UpdatePage.class_eval do
      include ::Decidim::MultipleAttachmentsMethods
      include ::Decidim::GalleryMethods

      def initialize(form, page)
        @form = form
        @page = page
        @attached_to = page
      end

      def call
        return broadcast(:invalid) if @form.invalid?

        if process_attachments?
          build_attachments
          return broadcast(:invalid) if attachments_invalid?
        end

        if process_gallery?
          build_gallery
          return broadcast(:invalid) if gallery_invalid?
        end

        transaction do
          update_page
          document_cleanup!
          photo_cleanup!
          create_attachments if process_attachments?
          create_gallery if process_gallery?
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

      attr_reader :form, :page, :current_user
    end
  end
end

::Decidim::Pages::Admin::UpdatePageDecorator.decorate
