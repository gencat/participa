# frozen_string_literal: true

# unless %W[development test].include? Rails.env
Rack::Attack.throttle("requests by (forwarded) ip", limit: 3, period: 60) do |request|
  # x_forwarded_for= request.get_header('X-Forwarded-For')
  x_forwarded_for= request.get_header("HTTP_X_FORWARDED_FOR")
  Rails.logger.warn ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For: #{x_forwarded_for}"
  if x_forwarded_for.present?
    ip= x_forwarded_for.split(":").first
    Rails.logger.warn ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For IP: #{ip}"
    ip
  else
    request.ip
  end
end
# end

__END__
headers= []
request.each_header {|h| headers << h };nil
h= Hash[headers]
h.keys

puts "HEADER: #{h.class}"
request.each_header {|h| puts "HEADER: #{h.first}" };nil

request.env["HTTP_X_FORWARDED_FOR"]
["rack.version", "rack.errors", "rack.multithread", "rack.multiprocess", "rack.run_once", "SCRIPT_NAME", "QUERY_STRING", "SERVER_PROTOCOL", "SERVER_SOFTWARE", "GATEWAY_INTERFACE", "REQUEST_METHOD", "REQUEST_PATH", "REQUEST_URI", "HTTP_VERSION", "HTTP_HOST", "HTTP_USER_AGENT", "HTTP_ACCEPT", "HTTP_X_FORWARDED_FOR", "puma.request_body_wait", "SERVER_NAME", "SERVER_PORT", "PATH_INFO", "REMOTE_ADDR", "puma.socket", "rack.hijack?", "rack.hijack", "rack.input", "rack.url_scheme", "rack.after_reply", "puma.config", "action_dispatch.parameter_filter", "action_dispatch.redirect_filter", "action_dispatch.secret_token", "action_dispatch.secret_key_base", "action_dispatch.show_exceptions", "action_dispatch.show_detailed_exceptions", "action_dispatch.logger", "action_dispatch.backtrace_cleaner", "action_dispatch.key_generator", "action_dispatch.http_auth_salt", "action_dispatch.signed_cookie_salt", "action_dispatch.encrypted_cookie_salt", "action_dispatch.encrypted_signed_cookie_salt", "action_dispatch.authenticated_encrypted_cookie_salt", "action_dispatch.use_authenticated_cookie_encryption", "action_dispatch.encrypted_cookie_cipher", "action_dispatch.signed_cookie_digest", "action_dispatch.cookies_serializer", "action_dispatch.cookies_digest", "action_dispatch.cookies_rotations", "action_dispatch.content_security_policy", "action_dispatch.content_security_policy_report_only", "action_dispatch.content_security_policy_nonce_generator", "action_dispatch.routes", "ROUTES_47055722000520_SCRIPT_NAME", "ORIGINAL_FULLPATH", "ORIGINAL_SCRIPT_NAME", "rack.cors", "action_dispatch.request_id", "action_dispatch.remote_ip", "rack.session", "rack.session.options", "rack.tempfiles", "decidim.current_organization", "HTTP_X_FORWARDED_HOST", "warden", "rack.attack.called"]
