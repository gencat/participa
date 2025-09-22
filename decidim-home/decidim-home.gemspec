# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/home/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-home"
  s.version = Decidim::Home::VERSION
  s.authors = ["Carlos Ordóñez"]
  s.email = ["cordonez@opentrends.net"]
  s.summary = "Summary of Decidim::Home."
  s.description = "Description of Decidim::Home."
  s.license = "MIT"
  s.required_ruby_version = ">= 3.2.9"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Home::DECIDIM_VER
  s.add_dependency "rails", ">= 7.0.8"
  s.metadata["rubygems_mfa_required"] = "true"
end
