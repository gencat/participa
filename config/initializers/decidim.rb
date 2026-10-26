# frozen_string_literal: true

Decidim.configure do |config|
  # The name of the application
  config.application_name = Decidim::Env.new("DECIDIM_APPLICATION_NAME", "My Application Name").to_s

  # The email that will be used as sender in all emails from Decidim
  config.mailer_sender = Decidim::Env.new("DECIDIM_MAILER_SENDER", "change-me@example.org").to_s

  # Change these lines to set your preferred locales
  config.available_locales = %w(en ca es oc)

  # Sets the default locale for new organizations. When creating a new
  # organization from the System area, system admins will be able to overwrite
  # this value for that specific organization.
  config.default_locale = Decidim::Env.new("DECIDIM_DEFAULT_LOCALE", "en").to_s.presence || :ca

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This component also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = Decidim::Env.new("DECIDIM_ENABLE_HTML_HEADER_SNIPPETS").present?

  # Allow organizations admins to track newsletter links.
  track_newsletter_links = Decidim::Env.new("DECIDIM_TRACK_NEWSLETTER_LINKS", "auto").default_or_present_if_exists.to_s
  config.track_newsletter_links = track_newsletter_links.present? unless track_newsletter_links == "auto"

  # Geocoder configuration
  # NOTE: to reenable the maps a new geocoder api token must be generated and replaced here. The `geocoder` gem has already been upgraded
  # config.maps = {
  #   provider: :here,
  #   api_key: Decidim::Env.new("GEOCODER_LOOKUP_API_KEY").to_s,
  #   static: { url: "https://image.maps.hereapi.com/mia/v3/base/mc/overlay" }
  # }

  # Decidim::Exporters::CSV's default column separator
  config.default_csv_col_sep = ","

  # Custom resource reference generator method
  # config.reference_generator = lambda do |resource, feature|
  #   # Implement your custom method to generate resources references
  #   "1234-#{resource.id}"
  # end

  # Currency unit
  # config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  # Machine Translation Configuration
  #
  # See Decidim docs at https://docs.decidim.org/en/develop/machine_translations/
  # for more information about how it works and how to set it up.
  #
  # Enable machine translations
  config.enable_machine_translations = Decidim::Env.new("ENABLE_MACHINE_TRANSLATIONS").to_boolean_string == "true"

  #
  # Machine translation service to interact with third party service to translate the user content.
  # See https://docs.decidim.org/en/develop/develop/machine_translations.html
  config.machine_translation_service = "ParticipaGencat::SoftcatalaTranslator"

  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  config.throttling_max_requests = Decidim::Env.new("DECIDIM_THROTTLING_MAX_REQUESTS", "100").to_i

  # Time window in which the throttling is applied.
  config.throttling_period = Decidim::Env.new("DECIDIM_THROTTLING_PERIOD", "1").to_i.minutes

  # How long can a user remained logged in before the session expires. Notice that
  # this is also maximum time that user can idle before getting automatically signed out.
  config.expire_session_after= (ENV["EXPIRE_SESSION_AFTER"].presence || 0.5).to_f.hours

  config.follow_http_x_forwarded_host = Decidim::Env.new("DECIDIM_FOLLOW_HTTP_X_FORWARDED_HOST").present?

  # OmniAuth providers. Same behaviour as the old `secrets.yml`: IdCat mòbil always
  # enabled, Facebook, Twitter and Google only enabled in the test environment.
  config.omniauth_providers = {
    facebook: {
      enabled: Rails.env.test?,
      app_id: ENV.fetch("OMNIAUTH_FACEBOOK_APP_ID", nil),
      app_secret: ENV.fetch("OMNIAUTH_FACEBOOK_APP_SECRET", nil),
      icon_path: "media/images/facebook.svg"
    },
    twitter: {
      enabled: Rails.env.test?,
      api_key: ENV.fetch("OMNIAUTH_TWITTER_API_KEY", nil),
      api_secret: ENV.fetch("OMNIAUTH_TWITTER_API_SECRET", nil),
      icon_path: "media/images/twitter-x.svg"
    },
    google_oauth2: {
      enabled: Rails.env.test?,
      client_id: ENV.fetch("OMNIAUTH_GOOGLE_CLIENT_ID", nil),
      client_secret: ENV.fetch("OMNIAUTH_GOOGLE_CLIENT_SECRET", nil),
      icon_path: "media/images/google.svg"
    },
    idcat_mobil: {
      enabled: true,
      client_id: ENV.fetch("IDCAT_MOBIL_CLIENT_ID", nil),
      client_secret: ENV.fetch("IDCAT_MOBIL_CLIENT_SECRET", nil),
      site: ENV.fetch("IDCAT_MOBIL_SITE_URL", nil),
      icon_path: "media/images/idcat_mobil-icon.svg"
    }
  }

  # Configure CSP for Algolia search for Decidim Finder
  config.content_security_policies_extra = {
    "connect-src" => %w(https://*.algolianet.com https://*.algolianet.net https://gencat.piwik.pro https://gencat.containers.piwik.pro),
    "img-src" => %w(https://*.algolianet.com https://*.algolianet.net https://www.googletagmanager.com https://gencat.containers.piwik.pro https://gencat.piwik.pro),
    "script-src" => %w(https://www.googletagmanager.com https://gencat.containers.piwik.pro https://www.youtube.com)
  }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)

if Decidim.module_installed? :verifications
  Decidim::Verifications.configure do |config|
    config.document_types = Decidim::Env.new("VERIFICATIONS_DOCUMENT_TYPES", "identification_number,passport").to_array
  end
end
