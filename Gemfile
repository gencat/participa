# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.29-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

#### Custom gems and modifications block start ####
# gem "decidim-cdtb", git: "https://github.com/CodiTramuntana/decidim-module-cdtb.git", branch: "main"
# gem "decidim-challenges", "~> 0.5.1"
# gem "decidim-department_admin", "~> 0.8.0"
# gem "decidim-home", path: "decidim-home"
# gem "decidim-idcat_mobil", git: "https://github.com/gencat/decidim-module-idcat_mobil.git", tag: "v0.5.0"
# gem "decidim-process-extended", path: "decidim-process-extended"
# gem "decidim-recaptcha", path: "decidim-recaptcha"
# gem "decidim-regulations", path: "decidim-regulations"
# gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git"
# gem "decidim-top_comments", path: "decidim-top_comments"
# gem "decidim-verifications-members_picker", "~> 0.0.7"
#### Custom gems and modifications block end ####

gem "soda-ruby", require: false
gem "stringio", "~> 3.1.7"

gem "puma"

# https://github.com/hlascelles/figjam
gem "figjam"
gem "wkhtmltopdf-binary"

gem "daemons"
gem "deface"
gem "delayed_job_active_record"

gem "whenever", require: false

gem "recaptcha"

# Error uninitialized constant WickedPdf::WickedPdfHelper::Assets::SprocketsEnvironment::Sprockets
# in update to 2.8.0
# https://github.com/mileszs/wicked_pdf/issues/1102

gem "wicked_pdf", "~> 2.8.0"

group :development, :test do
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "rubocop-faker"
  # Set versions because Property AutoCorrect errors.
  gem "rspec-rails"
  gem "rubocop-factory_bot", "2.26", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
end

group :development do
  gem "letter_opener_web", "~> 3.0"
  gem "listen"
  gem "web-console"
end

group :test do
  gem "capybara-screenshot"
  gem "database_cleaner"
end
