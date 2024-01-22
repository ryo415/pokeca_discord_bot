Sidekiq.configure_server do |config|
  # redisの設定
  config.redis = {url: "redis://#{Settings.redis.host}:#{Settings.redis.port}"}
end

Sidekiq.configure_client do |config|
  # redisの設定
  config.redis = {url: "redis://#{Settings.redis.host}:#{Settings.redis.port}"}
end