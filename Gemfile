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
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'codeclimate-test-reporter'
  gem 'mocha'
  gem 'pry-byebug'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'spring'
  gem 'timecop'
  gem 'webmock'
end
