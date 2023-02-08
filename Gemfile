# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.26-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

#### Custom gems and modifications block start ####
gem "decidim-admin-extended", path: "decidim-admin-extended"
gem "decidim-home", path: "decidim-home"
gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-recaptcha", path: "decidim-recaptcha"
gem "decidim-regulations", path: "decidim-regulations"
gem "decidim-top_comments", path: "decidim-top_comments"
gem "decidim-type", path: "decidim-type"

gem "decidim-challenges", git: "https://github.com/gencat/decidim-module-challenges.git", tag: "v0.2.0"
gem "decidim-department_admin", git: "https://github.com/gencat/decidim-module-department_admin.git", tag: "v6.0.0"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git"
#### Custom gems and modifications block end ####

gem "decidim-idcat_mobil", "~> 0.2.1"

gem "decidim-verifications-members_picker", git: "https://github.com/gencat/decidim-verifications-members_picker.git", tag: "0.0.4"
gem "soda-ruby", require: false

gem "puma", "< 6"
gem "rack-attack"

gem "figaro", ">= 1.1.1"

gem "daemons"
gem "deface"
gem "delayed_job_active_record"

gem "whenever", require: false

gem "ipaddr"
gem "recaptcha"

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
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :test do
  gem "database_cleaner"
end
