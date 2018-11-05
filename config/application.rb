require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Participa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.i18n.available_locales = %w(en ca es)

    # Processes group ids used to determine whether a process is a regulation or a process
    config.process    = 1
    config.regulation = 2

    config.photos = ['image1.png', 
          'image2.png',
          'image3.png',
          'image4.png',
          'image5.png']

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
