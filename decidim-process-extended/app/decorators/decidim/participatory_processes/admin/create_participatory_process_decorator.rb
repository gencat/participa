# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator
  def self.decorate
    klass = Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcess
    klass.class_eval do
      fetch_form_attributes :organization, :title, :subtitle, :weight, :slug, :hashtag, :description,
                            :short_description, :promoted, :taxonomizations, :announcement,
                            :private_space, :developer_group, :local_area, :target,
                            :participatory_scope, :participatory_structure, :meta_scope, :start_date, :end_date,
                            :participatory_process_group,
                            :cost, :has_summary_record, :promoting_unit, :facilitators, :email

      private

      # Used by Decidim::Process::Extended::NotifyAdminsOnCreate
      def notification_dates
        [resource.start_date, resource.end_date]
      end
    end
    klass.prepend(Decidim::Process::Extended::NotifyAdminsOnCreate) unless klass.ancestors.include?(Decidim::Process::Extended::NotifyAdminsOnCreate)
  end
end

Decidim::ParticipatoryProcesses::Admin::CreateParticipatoryProcessDecorator.decorate
