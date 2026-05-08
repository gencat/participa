# frozen_string_literal: true

# This decorator override +metadata_items+ to add gencat custom fields.
module Cells::Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCellDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCell.class_eval do
      private

      def metadata_items
        %w(meta_scope developer_group local_area target participatory_scope participatory_structure area_name
          promoting_unit facilitators cost has_summary_record email)
      end
    end
  end
end

Cells::Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCellDecorator.decorate
