# frozen_string_literal: true

module Decidim::DecidimFormHelperDecorator
  def self.decorate
    Decidim::DecidimFormHelper.class_eval do
      def types_for_select
        Decidim::ParticipatoryProcessType.all
      end
    end
  end
end

::Decidim::DecidimFormHelperDecorator.decorate
