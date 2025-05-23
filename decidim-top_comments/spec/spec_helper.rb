# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path = File.expand_path(File.join("spec", "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

if ENV["PARTICIPA_SIMPLECOV"]
  require "simplecov"
  SimpleCov.start do
    # `ENGINE_ROOT` holds the name of the engine we're testing.
    # This brings us to the main Decidim folder.
    root File.expand_path(".", ENV.fetch("ENGINE_ROOT", nil))

    # We make sure we track all Ruby files, to avoid skipping unrequired files
    # We need to include the `../` section, otherwise it only tracks files from the
    # `ENGINE_ROOT` folder for some reason.
    # track_files "../**/*.rb"

    # We ignore some of the files because they are never tested
    add_filter "/config/"
    add_filter "/db/"
    add_filter "/vendor/"
    add_filter "/spec/"
    add_filter "/test/"
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/engine.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/admin-engine.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/component.rb}
    add_filter %r{^/decidim-[^/]*/lib/decidim/[^/]*/participatory_space.rb}
  end

  SimpleCov.merge_timeout 1800

  if ENV["CI"]
    require "simplecov-cobertura"
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
end
