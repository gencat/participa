# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = Decidim.config.mailer_sender
end
