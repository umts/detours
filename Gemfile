source 'https://rubygems.org'

gem 'coffee-rails'
gem 'factory_girl_rails'
gem 'haml'
gem 'haml-lint'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'koala'
gem 'mysql'
gem 'paper_trail'
gem 'rails', '~> 4.2'
gem 'rubocop'
gem 'sass-rails'
gem 'snappconfig'
gem 'twitter'
gem 'uglifier'
gem 'whenever'

group :production do
  gem 'exception_notification'
end

group :production, :development do
  source 'https://rails-assets.org' do
    gem 'rails-assets-datetimepicker'
  end
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', require: false
end

group :development, :test do
  gem 'better_errors', require: false
  gem 'binding_of_caller', require: false
  gem 'codeclimate-test-reporter'
  gem 'fuubar', require: false
  gem 'guard-rspec', require: false
  gem 'mocha'
  gem 'pry-byebug', require: false
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'timecop'
end
