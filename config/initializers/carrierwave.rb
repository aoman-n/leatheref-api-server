CarrierWave.configure do |config|
  # config.fog_provider = 'fog/aws'

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.S3_ACCESS_KEY,
    aws_secret_access_key: Rails.application.credentials.S3_SECRET_KEY,
    region: Rails.application.credentials.S3_REGION,
  }

  # config.cache_storage = :fog
  # config.cache_dir = 'tmp/image-cache'

  case Rails.env
  when 'production'
    config.fog_directory  = Rails.application.credentials.S3_BUCKET
  when 'staging'
    config.fog_directory  = Rails.application.credentials.S3_BUCKET
  when 'development'
    config.fog_directory  = Rails.application.credentials.S3_BUCKET
  when 'test'
    config.fog_directory  = Rails.application.credentials.S3_BUCKET
  end

  if Rails.env.production?
    # TODO: プロダクション用に書き換える
    config.asset_host = 'https://production.com'
  else
    config.asset_host = 'http://localhost:3000'
  end
end
