require 'rails_helper'

# In this file, rather than globally stubbing out Twitter API requests,
# we stub them out only in before blocks, so that the call will still be made
# in the actual specs (so we can explicitly MOCK those).

describe Post do
  describe 'twitter_change!' do
    before :each do

    end
  end

  describe 'twitter_end!'

  describe 'twitter_start!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
      @tweet = Twitter::Tweet.new id: 100
      expect_any_instance_of(Twitter::REST::Client)
        .to receive(:update)
        .with(@post.short_text)
        .and_return @tweet
    end
    let :call do
      @post.twitter_start!
    end
    it 'creates a tweet with the short text and saves the ID' do
      call
      expect(@post.twitter_post_id).to eql 100
    end
  end

  describe 'self.update_twitter!'
end
