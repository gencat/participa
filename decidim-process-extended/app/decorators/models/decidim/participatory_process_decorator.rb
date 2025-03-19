# frozen_string_literal: true

module Models::Decidim::ParticipatoryProcessDecorator
  def self.decorate
    Decidim::ParticipatoryProcess.class_eval do
      def regulation?
        Decidim::ParticipatoryProcess
          .where(id:)
          .pick(:decidim_participatory_process_group_id) == Rails.application.config.regulation
      end
    end
  end
end

::Models::Decidim::ParticipatoryProcessDecorator.decorate
