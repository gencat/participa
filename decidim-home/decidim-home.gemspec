$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/home/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-home"
  s.version     = Decidim::Home::VERSION
  s.authors     = ["Carlos Ordóñez"]
  s.email       = ["cordonez@opentrends.net"]
  s.summary     = "Summary of Decidim::Home."
  s.description = "Description of Decidim::Home."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.2", "< 6.0.x"
  s.add_dependency "decidim-core"

  s.add_development_dependency "sqlite3"
end
