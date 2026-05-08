# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcess.class_eval do
      fetch_form_attributes :title, :subtitle, :weight, :slug, :hashtag, :promoted, :description,
                            :short_description, :taxonomizations,
                            :private_space, :developer_group, :local_area, :target, :participatory_scope,
                            :participatory_structure, :meta_scope, :start_date, :end_date, :participatory_process_group,
                            :announcement,
                            :cost, :has_summary_record, :promoting_unit, :facilitators, :email
    end
  end
end

Decidim::ParticipatoryProcesses::Admin::UpdateParticipatoryProcessDecorator.decorate
