# frozen_string_literal: true

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

require "decidim/extensions/locale_switcher_extension"
Decidim::ApplicationController
  .prepend(Decidim::Extensions::LocaleSwitcherExtension)
