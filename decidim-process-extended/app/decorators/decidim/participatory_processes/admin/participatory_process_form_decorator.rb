# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm.class_eval do
  attribute :facilitators, String
  attribute :promoting_unit, String

  attribute :cost, Float

  attribute :has_summary_record, Virtus::Attribute::Boolean

  # Participa added attributes
  attribute :type_id, Integer
  attribute :email, String
  attribute :show_home, Virtus::Attribute::Boolean

  validates :type, presence: true, if: proc { |object| object.type_id.present? }

  # after_save :example_function
  def map_model(model)
    self.scope_id = model.decidim_scope_id
    self.participatory_process_group_id = model.decidim_participatory_process_group_id
    self.type_id = model.decidim_type_id
    self.related_process_ids = model.linked_participatory_space_resources(:participatory_process, "related_processes").pluck(:id)
    @processes = Decidim::ParticipatoryProcess.where(organization: model.organization).where.not(id: model.id)
  end

  def type
    @type ||= current_organization.types.find_by(id: type_id)
  end
end
