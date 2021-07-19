Sidekiq::Extensions.enable_delay!

redis_url = ENV['REDIS_URL'] || 'redis://127.0.0.1:6379/1'
Sidekiq.configure_client do |config|
  config.redis = { namespace: 'sslguala', url:  redis_url }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'sslguala', url: redis_url}
end