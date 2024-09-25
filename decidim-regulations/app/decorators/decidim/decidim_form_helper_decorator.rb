# frozen_string_literal: true

module Decidim::DecidimFormHelperDecorator
  def self.decorate
    Decidim::DecidimFormHelper.class_eval do
      def types_for_select(current_organization)
        Decidim::ParticipatoryProcessType.where(decidim_organization_id: current_organization.id)
      end
    end
  end
end

::Decidim::DecidimFormHelperDecorator.decorate
