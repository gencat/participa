# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Participa"
  config.mailer_sender = ENV.fetch("SMTP_USERNAME") { "participagencat@gencat.cat" }

  # Change these lines to set your preferred locales
  config.default_locale = :ca
  config.available_locales = [:en, :ca, :es, :oc]

  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  # config.throttling_max_requests = 30

  # Time window in which the throttling is applied.
  # config.throttling_period = 1.minute

  # Geocoder configuration
  # NOTE: to reenable the maps a new geocoder api token must be generated and replaced here. The `geocoder` gem has already been upgraded
  # config.geocoder = {
  #   static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
  #   here_app_id: Rails.application.secrets.geocoder[:here_app_id],
  #   here_app_code: Rails.application.secrets.geocoder[:here_app_code]
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
end

Decidim.menu :menu do |menu|
  menu.item I18n.t("decidim.menu.meetings_static"), "/meetings", position: 3, active: :inclusive
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
