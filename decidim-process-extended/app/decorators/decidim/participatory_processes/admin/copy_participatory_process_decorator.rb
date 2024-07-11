# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Admin::CopyParticipatoryProcess.class_eval do
  def copy_participatory_process
    @copied_process = Decidim::ParticipatoryProcess.create!(
      organization: @participatory_process.organization,
      title: form.title,
      subtitle: @participatory_process.subtitle,
      slug: form.slug,
      hashtag: @participatory_process.hashtag,
      description: @participatory_process.description,
      short_description: @participatory_process.short_description,
      promoted: @participatory_process.promoted,
      scope: @participatory_process.scope,
      developer_group: @participatory_process.developer_group,
      local_area: @participatory_process.local_area,
      area: @participatory_process.area,
      target: @participatory_process.target,
      participatory_scope: @participatory_process.participatory_scope,
      participatory_structure: @participatory_process.participatory_structure,
      meta_scope: @participatory_process.meta_scope,
      start_date: @participatory_process.start_date,
      end_date: @participatory_process.end_date,
      participatory_process_group: @participatory_process.participatory_process_group,
      private_space: @participatory_process.private_space,

      # Participa added attributes
      cost: @participatory_process.cost,
      has_summary_record: @participatory_process.has_summary_record,
      promoting_unit: @participatory_process.promoting_unit,
      facilitators: @participatory_process.facilitators,
      email: @participatory_process.email,
      decidim_type_id: @participatory_process.decidim_type_id
    )
  end
end
