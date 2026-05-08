# frozen_string_literal: true

# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Decidim::Admin::NewslettersHelperDecorator
  def self.decorate
    Decidim::Admin::NewslettersHelper.class_eval do
      def participatory_space_types_form_object(form_object, space_type)
        return if spaces_user_can_admin[space_type.manifest_name.to_sym].blank?

        html = ""
        form_object.fields_for "participatory_space_types[#{space_type.manifest_name}]", space_type do |ff|
          html += participatory_space_title(space_type)
          html += ff.hidden_field :manifest_name, value: space_type.manifest_name
          html += select_tag_participatory_spaces(space_type, spaces_for_select(space_type), ff)
        end
        html.html_safe
      end

      def participatory_space_title(space_type)
        return unless space_type

        content_tag :h4 do
          label_text_for(space_type)
        end
      end

      def select_tag_participatory_spaces(space_type, spaces, child_form)
        return unless spaces

        raw(cell("decidim/admin/multi_select_picker", nil, context: {
                   select_id: "#{space_type.manifest_name}-spaces-select",
                   field_name: "#{child_form.object_name}[ids][]",
                   options_for_select: spaces,
                   selected_values: selected_options(:participatory_space_types)[space_type.manifest_name] || [],
                   placeholder: t("select_recipients_to_deliver.select_#{space_type.manifest_name}", scope: "decidim.admin.newsletters"),
                   class: "mb-2",
                   label: label_text_for(space_type)
                 }))
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
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity

Decidim::Admin::NewslettersHelperDecorator.decorate
