# frozen_string_literal: true

module Decidim::Assemblies::Admin::CreateAssemblyDecorator
  def self.decorate
    klass = Decidim::Assemblies::Admin::CreateAssembly
    klass.class_eval do
      private

      # Used by Decidim::Process::Extended::NotifyAdminsOnCreate
      def notification_dates
        [resource.creation_date, resource.closing_date]
      end
    end
    klass.prepend(Decidim::Process::Extended::NotifyAdminsOnCreate) unless klass.ancestors.include?(Decidim::Process::Extended::NotifyAdminsOnCreate)
  end
end

Decidim::Assemblies::Admin::CreateAssemblyDecorator.decorate
