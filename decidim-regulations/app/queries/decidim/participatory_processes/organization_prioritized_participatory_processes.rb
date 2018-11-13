# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # This query class filters public processes given an organization and a
    # filter in a meaningful prioritized order.
    class OrganizationPrioritizedParticipatoryProcesses < Rectify::Query
      def initialize(organization, filter = "active", regulation = false, filter_type = 0, theme_type = 0, status = 0)
        @organization = organization
        @filter = filter
        @regulation = regulation
        @filter_type = filter_type
        @theme_type = theme_type
        @status = status
      end

      def query
        Rectify::Query.merge(
          OrganizationParticipatoryProcesses.new(@organization),
          PublishedParticipatoryProcesses.new,
          PrioritizedParticipatoryProcesses.new,
          FilteredParticipatoryProcesses.new(@filter, @regulation, @filter_type, @theme_type, @status)
        ).query
      end
    end
  end
end