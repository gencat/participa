# frozen_string_literal: true

module Decidim::Admin::CreateStaticPageDecorator
  def self.decorate
    Decidim::Admin::CreateStaticPage.class_eval do
      include ::Decidim::MultipleAttachmentsMethods

      alias_method :original_run_before_hooks, :run_before_hooks
      alias_method :original_run_after_hooks, :run_after_hooks

      def run_before_hooks
        original_run_before_hooks

        return unless process_attachments?

        build_attachments
        raise Decidim::Commands::HookError if attachments_invalid?
      end

      def run_after_hooks
        original_run_after_hooks

        @attached_to = resource
        create_attachments(first_weight: 1) if process_attachments?
      end
    end
  end
end

Decidim::Admin::CreateStaticPageDecorator.decorate
