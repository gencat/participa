# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Figjam requires config/application.yml when the app boots. The dummy app is
# regenerated from scratch on each run, so we patch InstallGenerator to create
# a stub file before any bin/rails command fires (the first one is
# `rails "shakapacker:binstubs"` inside install_decidim_webpacker, before recreate_db).
require "decidim/generators/install_generator"

DUMMY_APP_YML = File.expand_path("spec/decidim_dummy_app/config/application.yml", __dir__)

module AppYmlStub
  def rails(*args)
    FileUtils.mkdir_p(File.dirname(DUMMY_APP_YML))
    FileUtils.touch(DUMMY_APP_YML) unless File.exist?(DUMMY_APP_YML)
    super
  end
end

Decidim::Generators::InstallGenerator.prepend(AppYmlStub)

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app"

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"
