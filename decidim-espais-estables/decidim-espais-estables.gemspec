$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/espais/estables/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-espais-estables"
  s.version     = Decidim::Espais::Estables::VERSION
  s.authors     = ["opentrends"]
  s.email       = ["info@opentrends.net"]
  s.summary     = "Extensions of decidim-assemblies"
  s.description = "Module that extends decidim-assemblies"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.2", "< 6.0.x"
  s.add_dependency "decidim-assemblies", ">=0.6.1"

  s.add_development_dependency "sqlite3"
end
