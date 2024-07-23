# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessFormDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm.class_eval do
      include Decidim::AttributeObject::Model

      # Participa added attributes
      attribute :facilitators, String
      attribute :promoting_unit, String
      attribute :cost, Float
      attribute :has_summary_record, :boolean
      attribute :type_id, Integer
      attribute :email, String

      validates :type, presence: true, if: proc { |object| object.type_id.present? }

      def map_model(model)
        self.scope_id = model.decidim_scope_id
        self.participatory_process_group_id = model.decidim_participatory_process_group_id
        self.participatory_process_type_id = model.decidim_participatory_process_type_id
        self.type_id = model.decidim_type_id
        self.related_process_ids = model.linked_participatory_space_resources(:participatory_process, "related_processes").pluck(:id)
        @processes = Decidim::ParticipatoryProcess.where(organization: model.organization).where.not(id: model.id)
      end

      def type
        @type ||= current_organization.types.find_by(id: type_id)
      end
    end
  end
end

::Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessFormDecorator.decorate
