# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.29-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-cdtb", git: "https://github.com/CodiTramuntana/decidim-module-cdtb.git", branch: "chore/rework_cdtb_rack_attack_to_parse_ips_as_expected"
gem "decidim-challenges", "~> 0.7.3"
gem "decidim-department_admin", git: "https://github.com/gencat/decidim-module-department_admin", tag: "v0.10.0"
gem "decidim-idcat_mobil", "~> 0.6.0"
gem "decidim-stratified_sortitions", git: "https://github.com/gencat/decidim-module-stratified_sortitions", branch: "main"
# PR pending to merge in mainio repo: https://github.com/mainio/decidim-module-term_customizer/pull/125
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer.git", branch: "upgrade/decidim_0.29"
gem "decidim-verifications-members_picker", github: "gencat/decidim-verifications-members_picker", tag: "v0.2.0"

# Internal modules
gem "decidim-home", path: "decidim-home"
gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-recaptcha", path: "decidim-recaptcha"
gem "decidim-regulations", path: "decidim-regulations"
gem "decidim-top_comments", path: "decidim-top_comments"

gem "soda-ruby", require: false
gem "stringio", "~> 3.1.7"
gem "uri", "~> 1.0.4"

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
  gem "rspec-rails"
  gem "rubocop-factory_bot", "2.26", require: false
  gem "rubocop-faker"
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
