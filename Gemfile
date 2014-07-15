source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'pg'
gem 'mysql'
gem 'foundation-rails'
gem 'high_voltage'

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'terminal-notifier-guard'
  gem 'shoulda-matchers'
end

gem 'sass-rails', '~> 4.0.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'
