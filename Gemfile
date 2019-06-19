source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'mysql2', '>= 0.3.18', '< 0.6.0'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
# gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 4.0'
gem 'bcrypt', '~> 3.1.7'
gem 'faker'
gem 'jwt'
gem 'rack-attack'
gem 'rack-cors'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'omniauth'
gem 'omniauth-twitter'

# 下記warnが出るため、一旦バージョンを指定したfogを使用する
# backend_1  | [fog][DEPRECATION] Fog::Storage::AWS is deprecated, please use Fog::AWS::Storage.
# backend_1  | [fog][WARNING] Unrecognized arguments: aws_access_key_id, aws_secret_access_key, region
# gem 'carrierwave'
# gem 'fog-aws'
# gem 'mini_magick'
gem 'carrierwave', '1.2.2'
gem 'mini_magick', '4.7.0'
gem 'fog', '1.42'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.11'
  gem 'rspec-rails', '~> 3.7'
  gem 'rubocop-airbnb'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'annotate'
  gem 'pry-byebug'
  gem 'rb-readline'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers',
      git: 'https://github.com/thoughtbot/shoulda-matchers.git',
      branch: 'rails-5'
end
