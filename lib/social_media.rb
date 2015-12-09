module SocialMedia
  # TODO: decide if we actually want to delete posts
  def facebook_change!
    facebook_client.delete_object facebook_post_id
    update facebook_post_id: nil
    facebook_start!
  end

  def facebook_client
    facebook_config = CONFIG.fetch :facebook
    Koala::Facebook::API.new(facebook_config.fetch :oauth_access_token)
  end

  def facebook_end!
    facebook_client.put_comment facebook_post_id, ending_text
    ending_post = facebook_client.put_wall_post ending_text
    update ending_facebook_post_id: ending_post.id
  end

  def facebook_start!
    post = facebook_client.put_wall_post text
    update facebook_post_id: post.id
  end

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

  def self.update_facebook!
    Post.current.where(facebook_post_id: nil).find_each(&:facebook_start!)
    Post.ended.where(ending_facebook_post_id: nil).find_each(&:facebook_end!)
  end

  def self.update_twitter!
    Post.current.where(twitter_post_id: nil).find_each(&:twitter_start!)
    Post.ended.where(ending_twitter_post_id: nil).find_each(&:twitter_end!)
  end
end
