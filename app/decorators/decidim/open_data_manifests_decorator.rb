# frozen_string_literal: true

# This decorator excludes the `metrics` core manifest from the Open Data export.
#
# Decidim loads the whole `decidim_metrics` table into memory to build its CSV,
# and with millions of rows the OpenDataJob gets killed by the OOM killer.
# Both the exporter and the open data page only use manifests with
# `include_in_open_data` set, so this also removes it from the view.
module Decidim::OpenDataManifestsDecorator
  EXCLUDED_MANIFESTS = [:metrics].freeze

  def self.decorate
    Decidim.singleton_class.class_eval do
      # Avoid aliasing twice when `to_prepare` runs again on code reload.
      next if method_defined?(:original_open_data_manifests)

      alias_method :original_open_data_manifests, :open_data_manifests

      def open_data_manifests
        original_open_data_manifests.map do |manifest|
          next manifest unless Decidim::OpenDataManifestsDecorator::EXCLUDED_MANIFESTS.include?(manifest.name)

          manifest.with(include_in_open_data: false)
        end
      end
    end
  end
end

Decidim::OpenDataManifestsDecorator.decorate
