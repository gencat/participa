# frozen_string_literal: true

# This decorator override +metadata_items+ to add gencat custom fields.
module Cells::Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCellDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCell.class_eval do
      private

      def metadata_items
        %w(participatory_scope target participatory_structure area_name meta_scope local_area developer_group
           promoting_unit facilitators cost has_summary_record email)
      end
    end
  end
end

Cells::Decidim::ParticipatoryProcesses::ContentBlocks::MetadataCellDecorator.decorate
