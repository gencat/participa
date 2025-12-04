# frozen_string_literal: true

require Rails.root.join("lib/middlewares/redirect_middleware")

Rails.application.config.middleware.use Middlewares::RedirectMiddleware
