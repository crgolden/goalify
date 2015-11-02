workers Integer(ENV['WEB_CONCURRENCY'])
threads Integer(ENV['MIN_THREADS']), Integer(ENV['MAX_THREADS'])
preload_app!
port ENV['PORT']
environment ENV['RACK_ENV']
on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
