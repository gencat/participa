# frozen_string_literal: true

# NOTE: This problem does NOT occur in newer versions of Decidim (>= 0.30).

# Fix for wicked_pdf 2.8.x when Sprockets is not available (app uses Shakapacker).
# The find_asset method falls through to SprocketsEnvironment which references
# the Sprockets constant that doesn't exist, causing:
#   uninitialized constant WickedPdf::WickedPdfHelper::Assets::SprocketsEnvironment::Sprockets
#
# See: https://github.com/mileszs/wicked_pdf/issues/1102
# See: https://github.com/decidim/decidim/issues/14764
#
# This was fixed upstream in decidim >= 0.30 by removing wicked_pdf entirely.

Rails.application.config.after_initialize do
  WickedPdf::WickedPdfHelper::Assets::SprocketsEnvironment.class_eval do
    def self.instance
      return nil unless defined?(Sprockets)

      @instance ||= Sprockets::Railtie.build_environment(Rails.application)
    end

    def self.find_asset(*args)
      return nil unless instance

      instance.find_asset(*args)
    end
  end
end
