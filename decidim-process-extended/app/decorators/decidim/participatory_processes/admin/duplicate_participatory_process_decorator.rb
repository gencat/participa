# frozen_string_literal: true

# Also copy the Participa custom fields when an admin duplicates a participatory process.
module Decidim::ParticipatoryProcesses::Admin::DuplicateParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::DuplicateParticipatoryProcess.class_eval do
      private

      def duplicate_participatory_process
        @duplicated_process = Decidim::ParticipatoryProcess.create!(
          organization: @participatory_process.organization,
          title: form.title,
          subtitle: @participatory_process.subtitle,
          slug: form.slug,
          description: @participatory_process.description,
          short_description: @participatory_process.short_description,
          promoted: @participatory_process.promoted,
          developer_group: @participatory_process.developer_group,
          local_area: @participatory_process.local_area,
          target: @participatory_process.target,
          participatory_scope: @participatory_process.participatory_scope,
          participatory_structure: @participatory_process.participatory_structure,
          meta_scope: @participatory_process.meta_scope,
          start_date: @participatory_process.start_date,
          end_date: @participatory_process.end_date,
          participatory_process_group: @participatory_process.participatory_process_group,
          private_space: @participatory_process.private_space,
          taxonomies: @participatory_process.taxonomies,

          # Participa added attributes
          cost: @participatory_process.cost,
          has_summary_record: @participatory_process.has_summary_record,
          promoting_unit: @participatory_process.promoting_unit,
          facilitators: @participatory_process.facilitators,
          email: @participatory_process.email
        )
      end
    end
  end
end

Decidim::ParticipatoryProcesses::Admin::DuplicateParticipatoryProcessDecorator.decorate
