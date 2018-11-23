workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count
stdout_redirect 'log/puma.log', 'log/puma_error.log', true
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

preload_app!

activate_control_app

rackup      DefaultRackup
port        ENV['PORT']     || 3000
env= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || :staging || :production
environment env
daemonize [:production, :staging, :integration].include?(env)

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
