# frozen_string_literal: true

module Middlewares
  class RedirectMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.starts_with?("/futur-europa")
        [301, { "Location" => request.url.sub("/futur-europa", "/processes/FuturEuropa") }, []]
      elsif request.path.starts_with?("/participacooperacio")
        [301, { "Location" => request.url.sub("/participacooperacio", "/processes/pladirectorcooperacio") }, []]
      else
        @app.call(env)
      end
    end
  end
end
