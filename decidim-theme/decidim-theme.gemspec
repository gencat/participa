$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/theme/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-theme"
  s.version     = Decidim::Theme::VERSION
  s.authors     = ["Carlos Ordóñez"]
  s.email       = ["cordonez@opentrends.net"]
  s.summary     = "Summary of Decidim::Theme."
  s.description = "Description of Decidim::Theme."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.3"

  s.add_development_dependency "sqlite3"
end
