Raven.configure do |config|
  config.dsn = ENV['SENTRY_URL']

  # config.async = lambda do |event|
  #   Raven.send_event(event)
  # end  
end