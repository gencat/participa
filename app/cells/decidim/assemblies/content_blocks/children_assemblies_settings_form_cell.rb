# frozen_string_literal: true

module Decidim
  module Assemblies
    module ContentBlocks
      # Settings form for the "Related assemblies" content block of the assembly
      # homepage. Adds the "list mode" checkbox to the original max results field.
      class ChildrenAssembliesSettingsFormCell < HighlightedAssembliesSettingsFormCell
        def list_mode_label
          I18n.t("decidim.assemblies.admin.content_blocks.children_assemblies.list_mode")
        end

        def list_mode_help
          I18n.t("decidim.assemblies.admin.content_blocks.children_assemblies.list_mode_help")
        end
      end
    end
  end
end
