source 'https://rubygems.org'

gem 'rails', '5.0.1'
gem 'pg', '~> 0.18'
gem 'devise'
gem 'cancancan'
gem 'puma'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'httparty'
gem 'net-sftp', '~> 2.1', '>= 2.1.2'
gem 'rails_admin'

gem 'therubyracer'

group :development, :test do
  gem 'byebug'
  gem "capistrano"
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'
  gem 'slackistrano'
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_girl_rails', :require => false
  gem 'mocha'
  gem 'simplecov'
  gem 'faker'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :staging, :development do
  gem 'letter_opener_web'
end

group :test do
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end
