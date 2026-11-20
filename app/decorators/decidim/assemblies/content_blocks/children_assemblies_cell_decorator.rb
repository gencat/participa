# frozen_string_literal: true

# Renders the children assemblies of the "Related assemblies" content block of
# the assembly homepage as a compact list (search card, `size: :s`) when the
# `list_mode` setting is enabled. Otherwise keeps the original grid.
#
# The `list_mode` setting is added in `config/initializers/children_assemblies_list_mode.rb`.
module Decidim::Assemblies::ContentBlocks::ChildrenAssembliesCellDecorator
  include Decidim::CardHelper

  def show
    return super unless list_mode?
    return unless total_count.positive?

    render :list
  end

  private

  def list_mode?
    model.settings.try(:list_mode).present?
  end
end

unless Decidim::Assemblies::ContentBlocks::ChildrenAssembliesCell.ancestors.include?(Decidim::Assemblies::ContentBlocks::ChildrenAssembliesCellDecorator)
  Decidim::Assemblies::ContentBlocks::ChildrenAssembliesCell.prepend(Decidim::Assemblies::ContentBlocks::ChildrenAssembliesCellDecorator)
end
