source "https://rubygems.org"

ruby "2.4.1"


gem "decidim", "0.7.4"

# Uncomment the following line if you want to use decidim-assemblies plugin
gem "decidim-assemblies", "0.7.4"
gem 'decidim-debates', path: 'decidim-debates'

gem 'decidim-department', path: 'decidim-department'
gem 'decidim-type', path: 'decidim-type'
gem 'decidim-theme', path: 'decidim-theme'
gem 'decidim-process-extended', path: 'decidim-process-extended'

gem 'decidim-meetings-extended', path: 'decidim-meetings-extended'
gem 'decidim-espais-estables', path: 'decidim-espais-estables'
gem 'decidim-regulations', path: 'decidim-regulations'
gem 'decidim-home', path: 'decidim-home'

gem "puma", "~> 3.0"
gem "uglifier", ">= 1.3.0"

gem "faker", "~> 1.8.4"

group :development, :test do
  gem "byebug", platform: :mri

  gem "decidim-dev", "0.7.4"
end

group :development do
  gem "web-console"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "letter_opener_web", "~> 1.3.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'decidim-selectable-news', path: 'decidim-selectable-news'
gem 'decidim-search-user', path: 'decidim-search-user'