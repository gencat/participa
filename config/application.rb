# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"
# Add the frameworks used by your app that are not loaded by Decidim.
# require "action_cable/engine"
# require "action_mailbox/engine"
# require "action_text/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Participa
  class Application < Rails::Application
    config.railties_order = [:main_app, Decidim::DepartmentAdmin::Engine, :all]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.i18n.available_locales = %w(en ca es oc)

    # Processes group ids used to determine whether a process is a regulation or a process
    config.process = 1
    config.regulation = 3

    config.photos = ["image1.png",
                     "image2.png",
                     "image3.png",
                     "image4.png",
                     "image5.png"]

    # Custom I18n fallbacks
    config.after_initialize do
      I18n.fallbacks = I18n::Locale::Fallbacks.new(
        ca: [:ca, :es, :en],
        es: [:es, :ca, :en],
        oc: [:oc, :ca, :es, :en]
      )
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths << Rails.root.join("lib")

    # Make decorators available
    config.to_prepare do
      Dir.glob("#{Rails.root}/app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
