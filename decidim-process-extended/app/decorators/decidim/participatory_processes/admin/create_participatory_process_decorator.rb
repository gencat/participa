# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess.class_eval do
  def attributes
    {
      organization: form.current_organization,
      title: form.title,
      subtitle: form.subtitle,
      weight: form.weight,
      slug: form.slug,
      hashtag: form.hashtag,
      description: form.description,
      short_description: form.short_description,
      hero_image: form.hero_image,
      banner_image: form.banner_image,
      promoted: form.promoted,
      scopes_enabled: form.scopes_enabled,
      scope: form.scope,
      scope_type_max_depth: form.scope_type_max_depth,
      private_space: form.private_space,
      developer_group: form.developer_group,
      local_area: form.local_area,
      area: form.area,
      target: form.target,
      participatory_scope: form.participatory_scope,
      participatory_structure: form.participatory_structure,
      meta_scope: form.meta_scope,
      start_date: form.start_date,
      end_date: form.end_date,
      participatory_process_group: form.participatory_process_group,
      show_metrics: form.show_metrics,
      show_statistics: form.show_statistics,
      announcement: form.announcement,

      # Participa added attributes
      cost: form.cost,
      has_summary_record: form.has_summary_record,
      promoting_unit: form.promoting_unit,
      facilitators: form.facilitators,
      email: form.email.downcase,
      decidim_type: form.type
    }
  end
end
