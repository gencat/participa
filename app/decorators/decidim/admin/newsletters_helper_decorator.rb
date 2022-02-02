# frozen_string_literal: true

Decidim::Admin::NewslettersHelper.class_eval do
  def participatory_space_types_form_object(form_object, space_type)
    return if spaces_user_can_admin[space_type.manifest_name.to_sym].blank?

    html = ""
    form_object.fields_for "participatory_space_types[#{space_type.manifest_name}]", space_type do |ff|
      html += ff.hidden_field :manifest_name, value: space_type.manifest_name
      html += select_tag_participatory_spaces(space_type, spaces_for_select(space_type), ff)
    end
    html.html_safe
  end

  def select_tag_participatory_spaces(space_type, spaces, child_form)
    return unless spaces

    tag.div(class: "#{space_type.manifest_name}-block spaces-block-tag cell small-12 medium-6") do
      child_form.select :ids, options_for_select(spaces),
                        { prompt: t("select_recipients_to_deliver.none", scope: "decidim.admin.newsletters"),
                          label: label_text_for(space_type),
                          include_hidden: false },
                        multiple: true, size: spaces.size > 10 ? 10 : spaces.size, class: "chosen-select"
    end
  end

  def label_text_for(space_type)
    if space_type.process_group_id
      Decidim::ParticipatoryProcessGroup.find(space_type.process_group_id).title[current_locale]
    else
      t("activerecord.models.decidim/#{space_type.manifest_name.singularize}.other")
    end
  end

  def spaces_for_select(space_type)
    return unless Decidim.participatory_space_manifests.map(&:name).include?(space_type.manifest_name.to_sym)

    collection = filter_spaces_by_process_group(space_type)
    return collection unless current_user.admin?

    [[I18n.t("select_recipients_to_deliver.all_spaces", scope: "decidim.admin.newsletters"), "all"]] + collection
  end

  def filter_spaces_by_process_group(space_type)
    manifest_name = space_type.manifest_name.to_sym
    return spaces_user_can_admin[manifest_name] unless manifest_name == :participatory_processes

    processes_ids = Decidim::ParticipatoryProcessGroup.find(space_type.process_group_id).participatory_processes.ids
    spaces_user_can_admin[manifest_name].select { |arr| arr[1].in? processes_ids }
  end
end
