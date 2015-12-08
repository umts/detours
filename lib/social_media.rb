module SocialMedia
  def twitter_client
    twitter_config = CONFIG.fetch :twitter
    Twitter::REST::Client.new do |config|
      config.consumer_key        = twitter_config.fetch :consumer_key
      config.consumer_secret     = twitter_config.fetch :consumer_secret
      config.access_token        = twitter_config.fetch :access_token
      config.access_token_secret = twitter_config.fetch :access_token_secret
    end
  end
end
