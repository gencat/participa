# frozen_string_literal: true

# This decorator override +metadata_valued_items+ to render two non string custom fields.
module Decidim::ContentBlocks::ParticipatorySpaceMetadataCellDecorator
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
            {
              title: t(item, scope: translations_scope),
              value: ActiveSupport::NumberHelper.number_to_currency(presented_space.send(item), unit: Decidim.currency_unit)
            }
          else
            next if (value = decidim_escape_translated(presented_space.send(item))).blank?

            {
              title: t(item, scope: translations_scope),
              value: value
            }
          end
        end
      end
    end
  end
end

::Decidim::ContentBlocks::ParticipatorySpaceMetadataCellDecorator.decorate
