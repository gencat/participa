# frozen_string_literal: true

# This decorator overrides Decidim::AssetRouter::Storage to generate permanent
# attachment URLs instead of temporary disk service URLs.
#
# By default, Decidim calls `blob.url()` directly for the disk service, which
# generates URLs like /rails/active_storage/disk/:token/filename that expire
# after 5 minutes. This decorator forces the use of `rails_blob_url` which
# respects the `config.active_storage.resolve_model_to_route = :rails_storage_proxy`
# setting and generates permanent URLs like /rails/active_storage/blobs/proxy/:signed_id/filename.
module Decidim::AssetRouter::StorageDecorator
  def self.decorate
    Decidim::AssetRouter::Storage.class_eval do
      private

      # Override blob_url to always use rails_blob_url instead of blob.url().
      # This ensures URLs go through the proxy route (permanent) instead of
      # the disk service route (temporary/expiring).
      # We force `only_path: true` to avoid "Missing host to link to!" errors,
      # since the host is not always available in the context where Decidim
      # generates these URLs (e.g. serializers, cells, background jobs).
      def blob_url(**options)
        return unless blob

        routes.rails_blob_url(blob, **default_options, **options, only_path: true)
      end
    end
  end
end

::Decidim::AssetRouter::StorageDecorator.decorate
