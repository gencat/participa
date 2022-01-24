Rails.application.config.middleware.use Middlewares::RedirectMiddleware
  # config.middleware.insert_before Warden::Manager, Middlewares::RedirectMiddleware
