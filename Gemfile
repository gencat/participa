source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim', branch: '0.20-stable' }.freeze

gem "decidim", DECIDIM_VERSION

#### Custom gems and modifciations block start ####
gem 'decidim-department_admin', git: 'https://github.com/gencat/decidim-department-admin.git', tag: 'v0.0.11'
gem 'decidim-process-extended', path: 'decidim-process-extended'
gem 'decidim-espais-estables', path: 'decidim-espais-estables'
gem 'decidim-regulations', path: 'decidim-regulations'
gem 'decidim-home', path: 'decidim-home'
gem 'decidim-admin-extended', path: 'decidim-admin-extended'
gem 'decidim-type', path: 'decidim-type'
#### Custom gems and modifications block end ####

gem 'rails', '< 6'
gem 'decidim-idcat_mobil', "~> 0.0.3"
gem 'soda-ruby', require: false
gem 'decidim-verifications-members_picker', git: 'https://github.com/gencat/decidim-verifications-members_picker.git', tag: '0.0.2'

gem "puma"
# force geocoder version until incompatibilities with Here are resolved in Decidim
gem "geocoder", "~> 1.5.2"
gem "uglifier", "~> 4.1"
# due to this alert: https://github.com/gencat/participa/network/alert/Gemfile.lock/devise/open
gem "devise", ">= 4.7.1"
# due to this alert: https://github.com/gencat/participa/network/alert/decidim-type/Gemfile.lock/nokogiri/open
gem "nokogiri", ">= 1.10.4"
# gem sprockets in version 4.0 breaks Decidim.Temporal fix at 10/10/2019
gem "sprockets", "~> 3.7.2"
# Temporal fix for: https://github.com/decidim/decidim/issues/5257 (Solved in v0.19)
gem "wicked_pdf"

gem 'figaro', '>= 1.1.1'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'whenever', require: false

group :development, :test do
  gem "faker", ">= 1.8.4"
  gem "byebug", platform: :mri
  gem "bootsnap"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "web-console"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "letter_opener_web", "~> 1.3.0"
end
