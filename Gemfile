# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/gencat/decidim", branch: "release/0.22-stable" }.freeze

gem "decidim", DECIDIM_VERSION

#### Custom gems and modifciations block start ####
gem "decidim-admin-extended", path: "decidim-admin-extended"
gem "decidim-department_admin", git: "https://github.com/gencat/decidim-department-admin.git", tag: "v0.0.16"
gem "decidim-espais-estables", path: "decidim-espais-estables"
gem "decidim-home", path: "decidim-home"
gem "decidim-process-extended", path: "decidim-process-extended"
gem "decidim-regulations", path: "decidim-regulations"
# having the gem enabled on :test env makes CI crash while trying to connect to DDBB before Rails boot is complete
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer", branch: "fix/participatory_space_not_being_retrieved_properly"
gem "decidim-top_comments", path: "decidim-top_comments"
gem "decidim-type", path: "decidim-type"
#### Custom gems and modifications block end ####

gem "decidim-idcat_mobil", git: "https://github.com/gencat/decidim-idcat_mobil.git", branch: "master"
gem "decidim-verifications-members_picker", git: "https://github.com/gencat/decidim-verifications-members_picker.git", tag: "0.0.2"
gem "rails", "< 6"
gem "soda-ruby", require: false

gem "puma", "< 5"
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
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener_web", "~> 1.3.0"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end

group :test do
  gem "database_cleaner"
end
