$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "participa/idcat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "participa-idcat"
  s.version     = Participa::Idcat::VERSION
  s.authors     = ["atouza"]
  s.email       = ["atouza@opentrends.net"]
  s.homepage    = "https://www.participa.gencat.cat"
  s.summary     = "Module to authenticate agains idCAT"
  s.description = "Module to authenticate agains idCAT"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
