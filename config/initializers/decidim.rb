# frozen_string_literal: true

Decidim.configure do |config|
  # The name of the application
  config.application_name = Rails.application.secrets.decidim[:application_name]

  # The email that will be used as sender in all emails from Decidim
  config.mailer_sender = Rails.application.secrets.decidim[:mailer_sender]

  # Change these lines to set your preferred locales
  config.available_locales = %w(en ca es oc)

  # Sets the default locale for new organizations. When creating a new
  # organization from the System area, system admins will be able to overwrite
  # this value for that specific organization.
  config.default_locale = Rails.application.secrets.decidim[:default_locale].presence || :ca

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
  config.enable_html_header_snippets = Rails.application.secrets.decidim[:enable_html_header_snippets].present?

  # Allow organizations admins to track newsletter links.
  config.track_newsletter_links = Rails.application.secrets.decidim[:track_newsletter_links].present? unless Rails.application.secrets.decidim[:track_newsletter_links] == "auto"

  # Geocoder configuration
  # NOTE: to reenable the maps a new geocoder api token must be generated and replaced here. The `geocoder` gem has already been upgraded
  # config.maps = {
  #   provider: :here,
  #   api_key: Rails.application.secrets.maps[:here_api_key],
  #   static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
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
  config.enable_machine_translations = Decidim::Env.new("ENABLE_MACHINE_TRANSLATIONS").to_boolean_string
  #
  # Machine translation service to interact with third party service to translate the user content.
  # See https://docs.decidim.org/en/develop/develop/machine_translations.html
  config.machine_translation_service = "ParticipaGencat::SoftcatalaTranslator"

  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  config.throttling_max_requests = (Rails.application.secrets.decidim[:throttling_max_requests] || 200).to_i

  # Time window in which the throttling is applied.
  config.throttling_period = (Rails.application.secrets.decidim[:throttling_period] || 1).to_i.minutes

  # How long can a user remained logged in before the session expires. Notice that
  # this is also maximum time that user can idle before getting automatically signed out.
  config.expire_session_after= (ENV["EXPIRE_SESSION_AFTER"].presence || 0.5).to_f.hours

  config.follow_http_x_forwarded_host = Rails.application.secrets.decidim[:follow_http_x_forwarded_host].present?

  # Configure CSP for Algolia search for Decidim Finder
  config.content_security_policies_extra = {
    "connect-src" => %w(https://*.algolianet.com https://*.algolianet.net),
    "img-src" => %w(https://*.algolianet.com https://*.algolianet.net),
    "script-src" => %w(https://www.googletagmanager.com)
  }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
