# frozen_string_literal: true

module Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeFormDecorator
  def self.decorate
    Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeForm.class_eval do
      attribute :process_group_id, Integer

      def map_model(model_hash)
        manifest = model_hash[:manifest]
        process_group_id = model_hash[:process_group_id]
        process_group_id ||= regulations_group_id if manifest.name == :participatory_processes

        self.manifest_name = manifest.name.to_s
        self.process_group_id = process_group_id
      end

      private

      def regulations_group_id
        Rails.application.config.regulation
      end
    end
  end
end

Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeFormDecorator.decorate
