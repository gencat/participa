# frozen_string_literal: true

# Use proxy mode instead of redirect mode for ActiveStorage URLs.
# This ensures attachment URLs are always the same and never change:
#   - Redirect mode (default): /rails/active_storage/blobs/redirect/:signed_id/:filename
#     → redirects to /rails/active_storage/disk/:encoded_token/:filename (EXPIRES after 5 min)
#   - Proxy mode: /rails/active_storage/blobs/proxy/:signed_id/:filename
#     → serves the file directly through Rails (PERMANENT, signed_id never expires)
#
# With proxy mode, the URL is deterministic and permanent for each blob.
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
