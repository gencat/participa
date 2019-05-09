# frozen_string_literal: true

Decidim::Admin::SelectiveNewsletterForm.class_eval do
  def map_model(_newsletter)
    self.participatory_space_types = Decidim.participatory_space_manifests.map do |manifest|
      Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeForm.from_model(manifest: manifest)
    end.unshift(additional_participatory_space_manifest)
  end

  private

  def additional_participatory_space_manifest
    Decidim::Admin::SelectiveNewsletterParticipatorySpaceTypeForm.from_model(
      manifest: Decidim.participatory_space_manifests.find { |m| m.name == :participatory_processes },
      process_group_id: process_group_id
    )
  end

  def process_group_id
    Rails.application.config.process
  end
end
