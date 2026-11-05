# frozen_string_literal: true

# Adds the creation date and creator filters used in the assemblies admin list
module Decidim::AssemblyCreationFiltersDecorator
  def self.decorate
    Decidim::Assembly.include(Participa::SpaceCreationFilters)
  end
end

Decidim::AssemblyCreationFiltersDecorator.decorate
