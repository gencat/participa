# frozen_string_literal: true

module Decidim::Admin::UpdateStaticPageDecorator
  def self.decorate
    Decidim::Admin::UpdateStaticPage.class_eval do
      include ::Decidim::MultipleAttachmentsMethods

      alias_method :original_attributes, :attributes
      alias_method :original_run_before_hooks, :run_before_hooks
      alias_method :original_run_after_hooks, :run_after_hooks

      def attributes
        parsed_content = form.content.transform_values do |value|
          Decidim::ContentProcessor.parse(value.to_s, current_organization: form.current_organization).rewrite
        end

        original_attributes.merge(content: parsed_content)
      end

      def run_before_hooks
        original_run_before_hooks

        @attached_to = resource

        return unless process_attachments?

        build_attachments
        raise Decidim::Commands::HookError if attachments_invalid?
      end

      def run_after_hooks
        original_run_after_hooks

        document_cleanup!(include_all_attachments: true)
        create_attachments(first_weight: first_attachment_weight) if process_attachments?
      end

      private

      def first_attachment_weight
        return 1 if resource.photos.count.zero?

        resource.photos.count
      end
    end
  end
end

Decidim::Admin::UpdateStaticPageDecorator.decorate
