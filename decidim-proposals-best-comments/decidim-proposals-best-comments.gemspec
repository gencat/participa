$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/proposals/best/comments/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-proposals-best-comments"
  s.version     = Decidim::Proposals::Best::Comments::VERSION
  s.authors     = ["Carlos Ordóñez"]
  s.email       = ["cordonez@opentrends.net"]
  s.summary     = "Summary of Decidim::Proposals::Best::Comments."
  s.description = "Description of Decidim::Proposals::Best::Comments."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.3"

  s.add_development_dependency "sqlite3"
end
