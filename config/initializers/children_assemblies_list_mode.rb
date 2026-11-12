# frozen_string_literal: true

# Adds a "list mode" option to the "Related assemblies" content block of the
# assembly homepage (children assemblies). When enabled, the children
# assemblies are rendered as a compact list (`card_for(assembly, size: :s)`)
# instead of the default grid of cards.
#
# Only this content block is affected: the settings form cell is replaced just
# for it, so the other blocks sharing `highlighted_assemblies_settings_form`
# (homepage highlighted assemblies and process homepage related assemblies)
# keep their original form.
#
# See also `app/decorators/decidim/assemblies/content_blocks/children_assemblies_cell_decorator.rb`.
Rails.application.config.after_initialize do
  manifest = Decidim.content_blocks.for(:assembly_homepage).find { |content_block| content_block.name == :related_assemblies }
  raise "Content block assembly_homepage/related_assemblies not found, cannot add list mode setting" if manifest.nil?

  manifest.settings_form_cell = "decidim/assemblies/content_blocks/children_assemblies_settings_form"
  manifest.settings do |settings|
    settings.attribute :list_mode, type: :boolean, default: false
  end
end
