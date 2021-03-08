# frozen_string_literal: true

# This migration comes from decidim_proposals (originally 20181016132225)

class AddOrganizationAsAuthor < ActiveRecord::Migration[5.2]
  def change
    Decidim::Proposals::Proposal.find_each do |proposal|
      proposal.add_coauthor(Decidim::Organization.first) if proposal.coauthorships.count.zero?
    end
  end
end
