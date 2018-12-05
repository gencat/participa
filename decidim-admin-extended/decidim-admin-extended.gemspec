$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/admin/extended/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-admin-extended"
  s.version     = Decidim::Admin::Extended::VERSION
  s.authors     = ["Isaac Massot"]
  s.email       = ["isaac.mg@coditramuntana.com"]
  s.summary     = "Summary of Decidim::Admin::Extended."
  s.description = "Description of Decidim::Admin::Extended"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", ">= 0.9.3"
  s.add_dependency "decidim-admin", ">= 0.9.3"

  s.add_development_dependency "decidim-admin", ">= 0.9.3"
  s.add_development_dependency "decidim-dev", ">= 0.9.3"
end
