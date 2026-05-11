# frozen_string_literal: true

module Decidim::Admin::UpdateStaticPageDecorator
  module Methods
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
        update_static_page
        document_cleanup!
        photo_cleanup!
        create_attachments if process_attachments?
        create_gallery if process_gallery?
        broadcast(:ok)
      end
    end

    def update_static_page
      parsed_content = form.content.transform_values do |value|
        Decidim::ContentProcessor.parse(value.to_s, current_organization: form.current_organization).rewrite
      end
      Decidim.traceability.update!(
        page,
        form.current_user,
        title: form.title,
        slug: form.slug,
        weight: form.weight,
        topic: form.topic,
        allow_public_access: form.allow_public_access,
        content: parsed_content
      )

      return unless form.changed_notably

      Decidim::Admin::UpdateOrganizationTosVersion.call(form.organization, page, form)
    end

    private

    attr_reader :form, :page, :current_user
  end

  def self.decorate
    Decidim::Admin::UpdateStaticPage.class_eval do
      include ::Decidim::MultipleAttachmentsMethods
      include ::Decidim::GalleryMethods

      def initialize(form, page)
        @form = form
        @page = page
        @attached_to = page
      end

      include Methods
    end
  end
end

Decidim::Admin::UpdateStaticPageDecorator.decorate
