# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = ENV.fetch("SMTP_USERNAME", "participagencat@gencat.cat")
end
