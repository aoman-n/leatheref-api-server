Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
           Rails.application.credentials.TWITTER_CONSUMER_KEY,
           Rails.application.credentials.TWITTER_CONSUMER_SECRET
  configure do |config|
    config.path_prefix = '/api/auth'
  end
end
