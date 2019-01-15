$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/meetings/extended/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-meetings-extended"
  s.version     = Decidim::Meetings::Extended::VERSION
  s.authors     = ["Carlos Ordóñez"]
  s.email       = ["cordonez@opentrends.net"]
  s.summary     = "Summary of Decidim::Meetings::Extended."
  s.description = "Description of Decidim::Meetings::Extended."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.2", "< 6.0.x"

  s.add_development_dependency "sqlite3"
end
