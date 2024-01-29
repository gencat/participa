# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Participa"
  config.mailer_sender = ENV.fetch("SMTP_USERNAME") { "participagencat@gencat.cat" }

  # Change these lines to set your preferred locales
  config.default_locale = :ca
  config.available_locales = [:en, :ca, :es, :oc]

  # Geocoder configuration
  # NOTE: to reenable the maps a new geocoder api token must be generated and replaced here. The `geocoder` gem has already been upgraded
  # config.maps = {
  #   provider: :here,
  #   api_key: Rails.application.secrets.maps[:api_key],
  #   static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  # }
  # config.geocoder = {
  #   timeout: 5,
  #   units: :km
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

  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  config.throttling_max_requests = (Rails.application.secrets.decidim[:throttling_max_requests] || 200).to_i

  # Time window in which the throttling is applied.
  config.throttling_period = (Rails.application.secrets.decidim[:throttling_period] || 1).to_i.minutes

  # How long can a user remained logged in before the session expires. Notice that
  # this is also maximum time that user can idle before getting automatically signed out.
  config.expire_session_after= 48.hours
end

Decidim.menu :menu do |menu|
  menu.item I18n.t("decidim.menu.meetings_static"), "/meetings", position: 3, active: :inclusive
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
