# frozen_string_literal: true

# Global security headers, including a deny-by-default Permissions-Policy.
# Apply consistently across environments so tests can catch policy regressions.
policy = [
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

Rails.application.config.action_dispatch.default_headers.merge!(
  "Permissions-Policy" => policy,
  "Cross-Origin-Opener-Policy" => "same-origin-allow-popups",
  "Cross-Origin-Embedder-Policy" => "unsafe-none",
  "Cross-Origin-Resource-Policy" => "same-origin"
)
