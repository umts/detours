module SocialMedia
  # TODO: decide if we actually want to delete tweets
  def twitter_change!
    tweet = twitter_client.status twitter_post_id
    twitter_client.destroy_status tweet
    update twitter_post_id: nil
    twitter_start!
  end

  def twitter_client
    twitter_config = CONFIG.fetch :twitter
    Twitter::REST::Client.new do |config|
      config.consumer_key        = twitter_config.fetch :consumer_key
      config.consumer_secret     = twitter_config.fetch :consumer_secret
      config.access_token        = twitter_config.fetch :access_token
      config.access_token_secret = twitter_config.fetch :access_token_secret
    end
  end

  def twitter_end!
    tweet = twitter_client.update short_ending_text
    update ending_twitter_post_id: tweet.id
  end

  def twitter_start!
    tweet = twitter_client.update short_text
    update twitter_post_id: tweet.id
  end

  def self.update_twitter!
    Post.current.where(twitter_post_id: nil).find_each(&:twitter_start!)
    Post.ended.where(ending_twitter_post_id: nil).find_each(&:twitter_end!)
  end
end
