# frozen_string_literal: true

module Participa
  # Ransack scopes used by the participatory processes and assemblies admin
  # lists to filter by creation date (whole days) and by creator.
  #
  # Spaces have no author column, so the creator is taken from two sources:
  #
  # - The action log of the `create` or `import` action. `duplicate` is left out
  #   because its log points to the original space, not to the copy.
  # - The PaperTrail version of the `create` event, which records the copies of
  #   duplicated spaces and some older spaces without action log.
  module SpaceCreationFilters
    extend ActiveSupport::Concern

    SCOPES = [:created_at_from_date, :created_at_to_date, :creator_search].freeze

    included do
      scope :created_at_from_date, lambda { |date|
        day = Participa::SpaceCreationFilters.parse_date(date)
        day ? where(arel_table[:created_at].gteq(day.in_time_zone.beginning_of_day)) : all
      }

      scope :created_at_to_date, lambda { |date|
        day = Participa::SpaceCreationFilters.parse_date(date)
        day ? where(arel_table[:created_at].lteq(day.in_time_zone.end_of_day)) : all
      }

      scope :creator_search, lambda { |term|
        term = term.to_s.strip
        next all if term.blank?

        users = Participa::SpaceCreationFilters.users_matching(term)
        logged = Participa::SpaceCreationFilters.created_in_action_logs(base_class.name, users)
        versioned = Participa::SpaceCreationFilters.created_in_versions(base_class.name, users)
        where(id: logged).or(where(id: versioned))
      }

      singleton_class.prepend(RansackableScopes)
    end

    module RansackableScopes
      def ransackable_scopes(auth_object = nil)
        scopes = super
        return scopes unless Participa::SpaceCreationFilters.admin_access?(auth_object)

        scopes + SCOPES
      end
    end

    class << self
      def parse_date(value)
        Date.iso8601(value.to_s)
      rescue Date::Error
        nil
      end

      def users_matching(term)
        Decidim::User.where(
          "decidim_users.name ILIKE :term OR decidim_users.nickname ILIKE :term OR decidim_users.email ILIKE :term",
          term: "%#{ActiveRecord::Base.sanitize_sql_like(term)}%"
        )
      end

      def created_in_action_logs(resource_type, users)
        Decidim::ActionLog
          .where(resource_type:, action: %w(create import), user_type: "Decidim::User", user_id: users.select(:id))
          .select(:resource_id)
      end

      def created_in_versions(item_type, users)
        gid_prefix = ActiveRecord::Base.connection.quote("gid://#{GlobalID.app}/Decidim::User/")

        versions = PaperTrail::Version.where(item_type:, event: "create")
        versions
          .where(whodunnit: users.select(Arel.sql("CONCAT(#{gid_prefix}, decidim_users.id)")))
          .or(versions.where(whodunnit: users.select(Arel.sql("decidim_users.id::text"))))
          .select(:item_id)
      end

      def admin_access?(user)
        return false unless user.is_a?(Decidim::User)

        user.admin? ||
          user.roles.any? ||
          Decidim::ParticipatoryProcessUserRole.exists?(user:) ||
          Decidim::AssemblyUserRole.exists?(user:)
      end
    end
  end
end
