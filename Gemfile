source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'


gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'redis-namespace'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'redis', '~> 4.0'
gem 'api_tools'
gem 'sentry-raven'
gem 'public_suffix'
gem 'foreman'
# Use Active Storage variant
gem 'image_processing', '~> 1.2'
gem 'newrelic_rpm'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.6', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'annotate'
  gem 'rubocop'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'friendly_id', '~> 5.4', '>= 5.4.1'
gem 'sidekiq', '~> 6.1', '>= 6.1.2'
gem 'sidekiq-scheduler'
gem 'name_of_person', '~> 1.1', '>= 1.1.1'
gem 'devise-jwt'
gem 'omniauth-wechat-oauth2'
gem 'pagy'
gem 'madmin'
gem 'figaro'
gem 'ransack'
gem 'rack-cors'
gem 'omniauth-rails_csrf_protection'
