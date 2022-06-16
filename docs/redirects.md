# Application Redirects
This application performs some custom redirects.

It uses a middleware to do it.

The infrastructure is a simple middleware that checks the incoming requests and performs a redirect if required.
The middleware is loaded by an initializer: `config/initializers/redirects.rb`

The middleware itself is: `lib/middlewares/redirect_middleware.rb`.
It is self contained, and the logic is self evident.
