# frozen_string_literal: true

require "rails_helper"
require "shared/space_creation_filters_examples"

describe Decidim::Assembly, versioning: true do
  let(:factory) { :assembly }
  let(:duplicate_space) do
    lambda do |assembly, user|
      form = double(
        invalid?: false,
        current_user: user,
        title: { en: "Duplicated assembly" },
        slug: "duplicated-assembly",
        duplicate_categories?: false,
        duplicate_components?: false,
        duplicate_landing_page_blocks?: false
      )
      copy = nil
      Decidim::Assemblies::Admin::DuplicateAssembly.call(form, assembly, user) do
        on(:ok) { |duplicated| copy = duplicated }
      end
      copy
    end
  end

  it_behaves_like "a space filterable by creation date and creator"
end
