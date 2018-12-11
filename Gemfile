source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "~> 0.11.2"

gem "decidim", DECIDIM_VERSION

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
gem 'decidim-search-user', path: 'decidim-search-user'
#### Custom gems and modifciations block end ####

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.0.0"

gem "faker", "~> 1.8.4"
gem 'figaro', '>= 1.1.1'

## Start force versions Gem
gem 'graphiql-rails', '1.4.11'
## End force versions Gem

group :development, :test do
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

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
