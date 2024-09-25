# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  # rubocop: disable RSpec/RepeatedExample
  it "Remove config/initializers/doorkeeper.rb and remove translations in admin.yml and surveys.yml after Decidim v0.28" do
    # > remove config/initializers/doorkeeper.rb as it is already configured in that version
    expect(Decidim.version).to be < "0.28"
  end

  it "Admin and Surveys must have multiple translations that need to be removed" do
    # > xx_admin.yml and xx_surveys.yml have multiple translations that
    # need to be removed if PR https://github.com/decidim/decidim/pull/11450/files gets merged into v0.28
    expect(Decidim.version).to be < "0.28"
  end

  it "Check and remove config/initializers/webpacker.rb" do
    expect(Decidim.version).to be < "0.28"
  end

  it "Make sure improvements in surveys have been merged" do
    # > make sure that PRs
    # - https://github.com/decidim/decidim/pull/11423
    # - https://github.com/decidim/decidim/pull/11450
    # have been backported to 0.28, otherwise we will need to do the backport in our fork
    expect(Decidim.version).to be < "0.28"
  end

  it "Remove private users translation" do
    # > remove key: participatory_space_private_user_csv_import.file in x_admin.yml because in 0.28 not exists this key
    expect(Decidim.version).to be < "0.28"
  end
  # rubocop: enable RSpec/RepeatedExample
end
