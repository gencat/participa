# frozen_string_literal: true

module Decidim::AttachmentsHelperDecorator
  def self.decorate
    Decidim::AttachmentsHelper.class_eval do
      def attachments_tab_panel_items(attached_to)
        [
          {
            enabled: attached_to.documents.any?,
            id: "documents",
            text: t("decidim.application.documents.documents"),
            icon: resource_type_icon_key("documents"),
            method: :cell,
            args: ["decidim/documents_panel", attached_to]
          },
          {
            enabled: attached_to.photos.any?,
            id: "images",
            text: t("decidim.application.photos.photos"),
            icon: resource_type_icon_key("images"),
            method: :cell,
            args: ["decidim/images_panel", attached_to]
          }
        ]
      end
    end
  end
end

::Decidim::AttachmentsHelperDecorator.decorate
