
module Middlewares
  class RedirectMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.starts_with?("/futur-europa")
        [301, {"Location" => request.url.sub("/futur-europa", "/processes/FuturEuropa")}, []]
      else
        @app.call(env)
      end
    end
  end
end
