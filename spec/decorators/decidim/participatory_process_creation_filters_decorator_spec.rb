# frozen_string_literal: true

require "rails_helper"
require "shared/space_creation_filters_examples"

describe Decidim::ParticipatoryProcess, versioning: true do
  let(:factory) { :participatory_process }
  let(:duplicate_space) do
    lambda do |process, user|
      form = double(
        invalid?: false,
        current_user: user,
        title: { en: "Duplicated process" },
        slug: "duplicated-process",
        duplicate_steps?: false,
        duplicate_components?: false,
        duplicate_landing_page_blocks?: false
      )
      copy = nil
      Decidim::ParticipatoryProcesses::Admin::DuplicateParticipatoryProcess.call(form, process) do
        on(:ok) { |duplicated| copy = duplicated }
      end
      copy
    end
  end

  it_behaves_like "a space filterable by creation date and creator"
end
