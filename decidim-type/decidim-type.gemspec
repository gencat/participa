# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/type/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-type"
  s.version = Decidim::Type::VERSION
  s.authors = ["Carlos Ordóñez"]
  s.email = ["cordonez@opentrends.net"]
  s.summary = "Summary of decidim-type"
  s.description = "Description of decidim-type"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Type::DECIDIM_VER
  s.add_development_dependency "decidim", Decidim::Type::DECIDIM_VER
  s.add_development_dependency "decidim-dev", Decidim::Type::DECIDIM_VER
end
