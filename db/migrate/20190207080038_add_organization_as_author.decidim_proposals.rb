# frozen_string_literal: true
# This migration comes from decidim_proposals (originally 20181016132225)

class AddOrganizationAsAuthor < ActiveRecord::Migration[5.2]
  def change
    default_organization = Decidim::Organization.first
    Decidim::Proposals::Proposal.find_each do |proposal|
      if proposal.coauthorships.count.zero?
        proposal.add_coauthor(default_organization)
      end
    end
  end
end
