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

  DECIDIM_VER = '>= 0.22'
  s.add_dependency "decidim-core", DECIDIM_VER
  s.add_dependency 'decidim-proposals', DECIDIM_VER
  s.add_dependency 'deface', '~> 1.5.3'
  s.add_development_dependency 'decidim', DECIDIM_VER
  s.add_development_dependency 'decidim-dev', DECIDIM_VER
end
