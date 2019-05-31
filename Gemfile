source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim', branch: 'master' }.freeze

gem "decidim", DECIDIM_VERSION

#### Custom gems and modifciations block start ####
gem 'decidim-department_admin', git: 'https://github.com/gencat/decidim-department-admin.git', tag: 'v0.0.6'
gem 'decidim-process-extended', path: 'decidim-process-extended'
gem 'decidim-espais-estables', path: 'decidim-espais-estables'
gem 'decidim-regulations', path: 'decidim-regulations'
gem 'decidim-home', path: 'decidim-home'
gem 'decidim-admin-extended', path: 'decidim-admin-extended'
gem 'decidim-type', path: 'decidim-type'
# Below gem is commented because the funcionalitiy is in 'decidim-department_admin' gem
# gem 'decidim-admin-search_user', path: 'decidim-admin-search_user'
#### Custom gems and modifications block end ####

gem 'decidim-idcat_mobil', "~> 0.0.3"
gem 'soda-ruby', require: false
gem 'decidim-verifications-members_picker', git: 'https://github.com/gencat/decidim-verifications-members_picker.git', tag: '0.0.2'

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.0.0"

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
