# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.28-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

#### Custom gems and modifications block start ####
gem "decidim-home", path: "decidim-home"
# gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-recaptcha", path: "decidim-recaptcha"
# gem "decidim-regulations", path: "decidim-regulations"
gem "decidim-top_comments", path: "decidim-top_comments"

gem "decidim-cdtb"
# gem "decidim-challenges", git: "https://github.com/gencat/decidim-module-challenges.git", tag: "v0.3.3"
# gem "decidim-department_admin", git: "https://github.com/gencat/decidim-module-department_admin.git", branch: "upgrade/0.27"
# gem "decidim-idcat_mobil", git: "https://github.com/gencat/decidim-module-idcat_mobil.git", branch: "upgrade/0.27"
# gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "release/0.27-stable"

# gem "decidim-verifications-members_picker", git: "https://github.com/gencat/decidim-verifications-members_picker.git", branch: "downgrade_ruby"
#### Custom gems and modifications block end ####

gem "soda-ruby", require: false

gem "puma"

# TODO: Psych problem: https://github.com/laserlemon/figaro/issues/289
# gem "figaro"
# This gem is an alternative to Figaro meanwhile fix that problem in Figaro.
# https://github.com/hlascelles/figjam
gem "figjam"

gem "daemons"
gem "deface"
gem "delayed_job_active_record"

gem "whenever", require: false

gem "recaptcha"

group :development, :test do
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "rubocop-faker"
  # Set versions because Property AutoCorrect errors.
  gem "rspec-rails", "~> 6.0.4"
  gem "rubocop-factory_bot", "2.25.1"
  gem "rubocop-rspec", "2.26.1"
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
