# frozen_string_literal: true

# Adds the creation date and creator filters used in the processes admin list
module Decidim::ParticipatoryProcessCreationFiltersDecorator
  def self.decorate
    Decidim::ParticipatoryProcess.include(Participa::SpaceCreationFilters)
  end
end

Decidim::ParticipatoryProcessCreationFiltersDecorator.decorate
