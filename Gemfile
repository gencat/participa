source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "~> 0.13.1"

gem "decidim", DECIDIM_VERSION

# TODO: remember to remove this forcing of rails
gem "rails", "5.2.0"

#### Custom gems and modifciations block start ####
gem 'decidim-admin-extended', path: 'decidim-admin-extended'
gem 'decidim-department', path: 'decidim-department'
gem 'decidim-type', path: 'decidim-type'
gem 'decidim-theme', path: 'decidim-theme'
gem 'decidim-process-extended', path: 'decidim-process-extended'
gem 'decidim-meetings-extended', path: 'decidim-meetings-extended'
gem 'decidim-espais-estables', path: 'decidim-espais-estables'
gem 'decidim-regulations', path: 'decidim-regulations'
gem 'decidim-home', path: 'decidim-home'
gem 'decidim-selectable-news', path: 'decidim-selectable-news'
gem 'decidim-admin-search_user', path: 'decidim-admin-search_user'
#### Custom gems and modifciations block end ####

gem 'decidim-idcat_mobil', "~> 0.0.1"

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.0.0"

gem 'figaro', '>= 1.1.1'

## Start force versions Gem
gem 'graphiql-rails', '1.4.11'
gem 'graphql', '1.8.10'
## End force versions Gem

group :development, :test do
  gem "faker", ">= 1.8.4"
  gem "byebug", platform: :mri

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
