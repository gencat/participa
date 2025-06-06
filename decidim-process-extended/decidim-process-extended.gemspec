# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/process/extended/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-process-extended"
  s.version = Decidim::Process::Extended::VERSION
  s.authors = ["Carlos Ordóñez"]
  s.email = ["cordonez@opentrends.net"]
  s.summary = "Summary of Decidim::Process::Extended."
  s.description = "Description of Decidim::Process::Extended."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Process::Extended::DECIDIM_VER
  s.add_dependency "rails", ">= 5.2", "< 7.0.x"
  s.add_development_dependency "decidim-dev", Decidim::Process::Extended::DECIDIM_VER
  s.metadata["rubygems_mfa_required"] = "true"
end
