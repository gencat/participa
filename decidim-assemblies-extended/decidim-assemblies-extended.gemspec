# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/assemblies/extended/version"

Gem::Specification.new do |s|
  s.version = Decidim::Assemblies::Extended::VERSION
  s.authors = ["spuigmitja"]
  s.email = ["Sergi.Puigmitja@dxcfds.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-assemblies-extended"
  s.summary = "Decidim assemblies module"
  s.description = "Assemblies component for decidim."

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Assemblies::Extended::VERSION

  s.add_development_dependency "decidim-admin", Decidim::Assemblies::Extended::VERSION
  s.add_development_dependency "decidim-dev", Decidim::Assemblies::Extended::VERSION
end