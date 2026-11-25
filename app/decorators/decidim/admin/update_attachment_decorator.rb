# frozen_string_literal: true

module Decidim::Admin::UpdateAttachmentDecorator
  def self.decorate
    Decidim::Admin::UpdateAttachment.class_eval do
      def call
        return broadcast(:invalid) if form.invalid?

        @attachment.assign_attributes(attributes)
        unless @attachment.valid?
          @attachment.errors[:file].each { |error| form.errors.add(:file, error) }
          return broadcast(:invalid)
        end

        Decidim.traceability.update!(@attachment, current_user, attributes)
        broadcast(:ok)
      end
    end
  end
end

Decidim::Admin::UpdateAttachmentDecorator.decorate
