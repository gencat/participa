# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim", branch: "release/0.24-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

#### Custom gems and modifciations block start ####
gem "decidim-admin-extended", path: "decidim-admin-extended"
gem "decidim-challenges", "0.0.11", git: "https://github.com/gencat/decidim-module-challenges.git"
gem "decidim-department_admin", "~> 0.4.2", git: "https://github.com/gencat/decidim-module-department_admin.git"
gem "decidim-home", path: "decidim-home"
gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-regulations", path: "decidim-regulations"
# having the gem enabled on :test env makes CI crash while trying to connect to DDBB before Rails boot is complete
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "0.24-stable"
gem "decidim-top_comments", path: "decidim-top_comments"
gem "decidim-type", path: "decidim-type"
#### Custom gems and modifications block end ####

gem "decidim-idcat_mobil", "0.1.0"
gem "decidim-verifications-members_picker", git: "https://github.com/gencat/decidim-verifications-members_picker.git", tag: "0.0.2"
gem "rails", "~> 5.2.6"
gem "soda-ruby", require: false

gem "puma", "< 6"
gem "rack-attack"

gem "uglifier", "~> 4.1"
# due to this alert: https://github.com/gencat/participa/network/alert/Gemfile.lock/devise/open
gem "devise", ">= 4.7.1"
# due to this alert: https://github.com/gencat/participa/network/alert/decidim-type/Gemfile.lock/nokogiri/open
gem "nokogiri", ">= 1.10.4"
# gem sprockets in version 4.0 breaks Decidim.Temporal fix at 10/10/2019
gem "sprockets", "< 4.0.0"
# Temporal fix for: https://github.com/decidim/decidim/issues/5257 (Solved in v0.19)
gem "wicked_pdf"

gem "figaro", ">= 1.1.1"

gem "daemons"
gem "deface"
gem "delayed_job_active_record"

gem "whenever", require: false

group :development, :test do
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", ">= 1.8.4"
  gem "rspec-rails"
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web", "~> 1.3.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :test do
  gem "database_cleaner"
end
