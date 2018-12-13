$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "decidim/admin/search_user/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim-admin-search_user"
  s.version     = Decidim::Admin::SearchUser::VERSION
  s.authors     = ["Carlos Ordóñez", "Isaac Massot"]
  s.email       = ["cordonez@opentrends.net", "isaac.mg@coditramuntana.com"]
  s.summary     = "Summary of Decidim::Admin::SearchUser."
  s.description = "Description of Decidim::Admin::SearchUser."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.2", "< 6.0.x"

  s.add_development_dependency "sqlite3"
end
