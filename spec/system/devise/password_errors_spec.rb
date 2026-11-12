# frozen_string_literal: true

require "rails_helper"

describe "Change password errors", type: :system do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:reset_password_token) { user.send(:set_reset_password_token) }

  before do
    switch_to_host(organization.host)
    visit decidim.edit_user_password_path(reset_password_token:)
  end

  it "shows the validation errors at the bottom of the form" do
    # Long enough to pass the browser validation, but rejected by Decidim (it is a common password)
    fill_in "user[password]", with: "secretsecret"
    within("form.new_user") { find("button[type='submit']").click }

    expect(page).to have_css("div.form__wrapper p.form-error[role='alert']")
  end

  it "does not show the errors before submitting" do
    expect(page).to have_no_css("div.form__wrapper p.form-error[role='alert']")
  end
end
