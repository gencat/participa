# frozen_string_literal: true

module Decidim::Pages::Admin::UpdatePageDecorator
  def self.decorate
    Decidim::Pages::Admin::UpdatePage.class_eval do
      include ::Decidim::MultipleAttachmentsMethods

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

        transaction do
          update_page
          document_cleanup!(include_all_attachments: true)
          create_attachments(first_weight: first_attachment_weight) if process_attachments?
        end

        broadcast(:ok)
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

      def first_attachment_weight
        return 1 if page.photos.count.zero?

        page.photos.count
      end
    end
  end
end

Decidim::Pages::Admin::UpdatePageDecorator.decorate
