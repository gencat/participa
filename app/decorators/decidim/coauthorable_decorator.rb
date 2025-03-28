# frozen_string_literal: true

module Decidim::CoauthorableDecorator
  def add_external_author(external_author_name, organization)
    external_author = Decidim::ExternalAuthor.find_or_create_by(name: external_author_name, organization:)

    return if coauthorships.exists?(decidim_author_id: external_author.id, decidim_author_type: external_author.class.base_class.name)

    generate_coauthorship(external_author)

    authors << external_author
  end

  def add_location(meeting_url)
    segment_id = meeting_url.split("/").last.to_i

    location = Decidim::Meetings::Meeting.find(segment_id)

    return if coauthorships.exists?(decidim_author_id: location.id, decidim_author_type: location.class.base_class.name)

    generate_coauthorship(location)

    authors << location
  end

  private

  def generate_coauthorship(new_author)
    coauthorship_attributes = { author: new_author }
    if persisted?
      coauthorships.create!(coauthorship_attributes)
    else
      coauthorships.build(coauthorship_attributes)
    end
  end
end

Decidim::Coauthorable.prepend Decidim::CoauthorableDecorator
