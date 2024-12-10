# frozen_string_literal: true

module Decidim::Admin::CreateStaticPageDecorator
  def self.decorate
    Decidim::Admin::CreateStaticPage.class_eval do
      include ::Decidim::AttachmentMethods

      def call
        return broadcast(:invalid) if form.invalid?

        if process_attachments?
          build_attachment
          return broadcast(:invalid) if attachment_invalid?
        end

        transaction do
          create_page
          create_attachment if process_attachments?
          update_organization_tos_version
          broadcast(:ok)
        end
      end

    end
  end
end

::Decidim::Admin::CreateStaticPageDecorator.decorate
