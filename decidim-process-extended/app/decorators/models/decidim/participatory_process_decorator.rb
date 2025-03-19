# frozen_string_literal: true

module Models::Decidim::ParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcess.class_eval do
      def is_regulation?
        Decidim::ParticipatoryProcess
          .where(id:)
          .pluck(:decidim_participatory_process_group_id)
          .first() == Rails.application.config.regulation
      end
    end
  end
end

::Models::Decidim::ParticipatoryProcessDecorator.decorate
