require 'codeclimate-test-reporter'
require 'factory_girl_rails'
require 'simplecov'
require 'webmock/rspec'

CodeClimate::TestReporter.start if ENV['CI']
SimpleCov.start 'rails'
SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
end

WebMock.disable_net_connect! allow_localhost: true

RSpec.configure do |config|
  config.before :all do
    FactoryGirl.reload
  end
  config.include FactoryGirl::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def stub_social_media_requests(&block)
  stub_social_media_requests!
  block.call
  unstub_social_media_requests!
end

def stub_social_media_requests!
  methods = %i(facebook_change!
               facebook_end!
               facebook_start!
               twitter_change!
               twitter_end!
               twitter_start!)
  methods.each do |method|
    allow_any_instance_of(Post).to receive method
  end
end

def unstub_social_media_requests!
  methods = %i(facebook_change!
               facebook_end!
               facebook_start!
               twitter_change!
               twitter_end!
               twitter_start!)
  methods.each do |method|
    allow_any_instance_of(Post).to receive(method).and_call_original
  end
end

def when_current_user_is(user)
  session[:user_id] = case user
                      when User
                        user
                      when :whoever
                        create :user
                      end.id
end
