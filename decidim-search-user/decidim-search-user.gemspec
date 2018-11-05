$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/search/user/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-search-user"
  s.version     = Decidim::Search::User::VERSION
  s.authors     = ["Carlos Ordóñez"]
  s.email       = ["cordonez@opentrends.net"]
  s.summary     = "Summary of Decidim::Search::User."
  s.description = "Description of Decidim::Search::User."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
