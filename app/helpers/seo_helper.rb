# frozen_string_literal: true

module SeoHelper
  ROBOTS_DISALLOWED_PATH_PREFIXES = %w(
    /profiles/
    /comments/
    /search/
    /system/
    /rails/
    /last_activities/
    /admin/
  ).freeze

  def seo_noindex_path?
    ROBOTS_DISALLOWED_PATH_PREFIXES.any? { |prefix| request.path.start_with?(prefix) }
  end
end
