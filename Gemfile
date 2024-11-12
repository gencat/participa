# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

#### Custom gems and modifications block start ####
gem "decidim-home", path: "decidim-home"
gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-recaptcha", path: "decidim-recaptcha"
gem "decidim-regulations", path: "decidim-regulations"
gem "decidim-top_comments", path: "decidim-top_comments"

gem "decidim-cdtb"
gem "decidim-challenges", git: "https://github.com/gencat/decidim-module-challenges.git", tag: "v0.3.3"
gem "decidim-department_admin", "~> 0.7.2"
gem "decidim-idcat_mobil"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "release/0.27-stable"

gem "decidim-verifications-members_picker", "~> 0.0.6.1"
#### Custom gems and modifications block end ####

gem "soda-ruby", require: false

gem "puma"

gem "figaro", ">= 1.1.1"

gem "daemons"
gem "deface"
gem "delayed_job_active_record"

gem "whenever", require: false

gem "recaptcha"

# Error uninitialized constant WickedPdf::WickedPdfHelper::Assets::SprocketsEnvironment::Sprockets
# in update to 2.8.0
# https://github.com/mileszs/wicked_pdf/issues/1102

gem "wicked_pdf", "~> 2.7.0"

group :development, :test do
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "rspec-rails"
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :test do
  gem "capybara-screenshot"
  gem "database_cleaner"
end
