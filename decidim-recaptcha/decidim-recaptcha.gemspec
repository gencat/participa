# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/recaptcha/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "decidim-recaptcha"
  s.version = Decidim::Recaptcha::VERSION
  s.authors = ["Laura Jaime"]
  s.email = ["laura.jv@coditramuntana.com"]
  s.summary = "Summary of Decidim::Recaptcha."
  s.description = "Description of Decidim::Recaptcha."
  s.license = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Recaptcha::DECIDIM_VER
  s.add_development_dependency "decidim", Decidim::Recaptcha::DECIDIM_VER
  s.add_development_dependency "decidim-dev", Decidim::Recaptcha::DECIDIM_VER
end
