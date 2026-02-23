# frozen_string_literal: true

require "rails_helper"

describe "ActiveStorage permanent URLs configuration" do
  it "resolves model to route using rails_storage_proxy" do
    expect(Rails.application.config.active_storage.resolve_model_to_route).to eq(:rails_storage_proxy)
  end
end
