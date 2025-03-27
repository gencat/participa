# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/top_comments/version"

Gem::Specification.new do |s|
  s.version = Decidim::TopComments.version
  s.authors = ["Oliver Valls"]
  s.email = ["199462+tramuntanal@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-top_comments"
  s.required_ruby_version = ">= 2.6"

  s.name = "decidim-top_comments"
  s.summary = "A decidim top_comments module"
  s.description = "Highlight in favor and against comments with more votes.."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::TopComments::DECIDIM_VER
  s.add_dependency "decidim-proposals", Decidim::TopComments::DECIDIM_VER
  s.add_dependency "deface"
  s.add_development_dependency "decidim", Decidim::TopComments::DECIDIM_VER
  s.add_development_dependency "decidim-dev", Decidim::TopComments::DECIDIM_VER
  s.metadata["rubygems_mfa_required"] = "true"
end
