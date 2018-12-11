# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Participa"
  config.mailer_sender = ENV.fetch("SMTP_USERNAME") { "participagencat@gencat.cat" }

  # Change these lines to set your preferred locales
  config.default_locale = :ca
  config.available_locales = [:en, :ca, :es, :oc]

  # Geocoder configuration
  config.geocoder = {
    static_map_url: "https://image.maps.cit.api.here.com/mia/1.6/mapview",
    here_app_id: Rails.application.secrets.geocoder[:here_app_id],
    here_app_code: Rails.application.secrets.geocoder[:here_app_code]
  }

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


Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
