# frozen_string_literal: true

require "rails_helper"

describe "Overrides and customizations" do
  it "before Decidim v0.24" do
    # ACTION -> re-enable erblint after Decidim v0.24
    # Check the file .github/workflows/linters.yml to re-enable erb-lint

    # ACTION -> depend upon gencat fork for CI migrations to work until Decidim 0.24
    # When at v0.24 we can depend upon decidim:decidim again
    # From gencat:decidim fork what we need is:
    # commit 54b7e3713cc971dd27bd790eaf31c0b727f1c839 (HEAD -> release/0.22-stable, origin/release/0.22-stable)
    #    Fix migration to avoid failing when generating test_app

    expect(Decidim.version).to be < "0.24"
  end
end
