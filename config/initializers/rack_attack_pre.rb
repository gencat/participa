# This initializer is to enable Rack Attack in the preproduction environment
if Rails.env.preprod?
  require "rack/attack"

  Rails.application.configure do |config|
    config.middleware.use Rack::Attack
  end

  ActiveSupport::Reloader.to_prepare do
    Rack::Attack.throttle(
      "requests by ip",
      limit: Decidim.throttling_max_requests,
      period: Decidim.throttling_period,
      &:ip
    )

    # Throttle login attempts for a given email parameter to 6 reqs/minute
    # Return the email as a discriminator on POST /users/sign_in requests
    Rack::Attack.throttle("limit logins per email", limit: 5, period: 60.seconds) do |request|
      request.params["user"]["email"] if request.path == "/users/sign_in" && request.post?
    end

    # Throttle login attempts for a given email parameter to 6 reqs/minute
    # Return the email as a discriminator on POST /users/sign_in requests
    Rack::Attack.throttle("limit password recovery attempts per email", limit: 5, period: 60.seconds) do |request|
      request.params["user"]["email"] if request.path == "/users/password" && request.post?
    end
  end
end
