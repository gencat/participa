# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/admin/extended/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-admin-extended"
  s.version = Decidim::Admin::Extended::VERSION
  s.authors = ["Isaac Massot"]
  s.email = ["isaac.mg@coditramuntana.com"]
  s.summary = "Summary of Decidim::Admin::Extended."
  s.description = "Description of Decidim::Admin::Extended"
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", Decidim::Admin::Extended::DECIDIM_VER
  s.add_dependency "decidim-core", Decidim::Admin::Extended::DECIDIM_VER

  s.add_development_dependency "decidim-admin", Decidim::Admin::Extended::DECIDIM_VER
  s.add_development_dependency "decidim-dev", Decidim::Admin::Extended::DECIDIM_VER
end
