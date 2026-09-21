# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Security headers", type: :request do
  let(:expected_permissions_policy) do
    [
      "accelerometer=()",
      "ambient-light-sensor=()",
      "attribution-reporting=()",
      "autoplay=()",
      "bluetooth=()",
      "browsing-topics=()",
      "camera=()",
      "clipboard-read=(self)",
      "clipboard-write=(self)",
      "display-capture=()",
      "encrypted-media=()",
      "fullscreen=(self)",
      "gamepad=()",
      "geolocation=()",
      "gyroscope=()",
      "hid=()",
      "identity-credentials-get=()",
      "idle-detection=()",
      "join-ad-interest-group=()",
      "keyboard-map=()",
      "local-fonts=()",
      "magnetometer=()",
      "microphone=()",
      "midi=()",
      "otp-credentials=()",
      "payment=()",
      "picture-in-picture=()",
      "publickey-credentials-create=(self)",
      "publickey-credentials-get=(self)",
      "run-ad-auction=()",
      "screen-wake-lock=()",
      "serial=()",
      "storage-access=()",
      "sync-xhr=(self)",
      "usb=()",
      "web-share=()",
      "window-management=()",
      "xr-spatial-tracking=()"
    ].join(", ")
  end

  let(:expected_cross_origin_opener_policy) { "same-origin-allow-popups" }
  let(:expected_cross_origin_embedder_policy) { "unsafe-none" }
  let(:expected_cross_origin_resource_policy) { "same-origin" }

  it "returns the configured security headers on the public root endpoint" do
    get "/"

    expect(response.status).to be_between(200, 399)
    expect(response.headers["Permissions-Policy"]).to eq(expected_permissions_policy)
    expect(response.headers["X-Frame-Options"]).to eq("SAMEORIGIN")
    expect(response.headers["Cross-Origin-Opener-Policy"]).to eq(expected_cross_origin_opener_policy)
    expect(response.headers["Cross-Origin-Embedder-Policy"]).to eq(expected_cross_origin_embedder_policy)
    expect(response.headers["Cross-Origin-Resource-Policy"]).to eq(expected_cross_origin_resource_policy)
  end
end
