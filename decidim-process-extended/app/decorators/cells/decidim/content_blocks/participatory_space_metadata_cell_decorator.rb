# frozen_string_literal: true

# This decorator override +metadata_valued_items+ to render two non string custom fields.
module Cells::Decidim::ContentBlocks::ParticipatorySpaceMetadataCellDecorator
  def self.decorate
    Decidim::ContentBlocks::ParticipatorySpaceMetadataCell.class_eval do
      private

      def metadata_valued_items
        metadata_items.filter_map do |item|
          if item == "has_summary_record"
            {
              title: t(item, scope: translations_scope),
              value: t("decidim.participatory_processes.participatory_processes.presenter.has_summary_record.#{presented_space.send(item)}")
            }
          elsif item == "cost"
            next if (value = presented_space.send(item)).nil?

            {
              title: t(item, scope: translations_scope),
              value: ActiveSupport::NumberHelper.number_to_currency(value, unit: Decidim.currency_unit)
            }
          else
            next if (value = decidim_escape_translated(presented_space.send(item))).blank?

            {
              title: t(item, scope: translations_scope),
              value:
            }
          end
        end
      end
    end
  end
end

::Cells::Decidim::ContentBlocks::ParticipatorySpaceMetadataCellDecorator.decorate
