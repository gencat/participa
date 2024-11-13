# frozen_string_literal: true

module Decidim::CoauthorableDecorator
  def add_external_author(external_author_name, organization)
    external_author = Decidim::ExternalAuthor.find_or_create_by(name: external_author_name, organization: organization)

    return if coauthorships.exists?(decidim_author_id: external_author.id, decidim_author_type: external_author.class.base_class.name)

    coauthorship_attributes = { author: external_author }

    if persisted?
      coauthorships.create!(coauthorship_attributes)
    else
      coauthorships.build(coauthorship_attributes)
    end

    authors << external_author
  end
end

::Decidim::Coauthorable.prepend ::Decidim::CoauthorableDecorator
