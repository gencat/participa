# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessFormDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm.class_eval do
      include Decidim::AttributeObject::Model

      # Participa added attributes
      translatable_attribute :facilitators, String
      translatable_attribute :promoting_unit, String
      attribute :cost, Float
      attribute :has_summary_record, :boolean
      attribute :email, String
    end
  end
end

Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessFormDecorator.decorate
