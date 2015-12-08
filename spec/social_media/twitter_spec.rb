require 'rails_helper'

# In this file, rather than globally stubbing out Twitter API requests,
# we stub them out only in before blocks, so that the call will still be made
# in the actual specs (so we can explicitly MOCK those).
#
# We don't test update_twitter since all it does is call already tested
# AR scopes or twitter methods.

describe Post do
  describe 'twitter_change!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'deletes the existing tweet, clears the ID, and calls twitter_start!' do
      expect_any_instance_of(Twitter::REST::Client)
        .to receive(:status)
        .with(@post.twitter_post_id)
        .and_return 'a tweet'
      expect_any_instance_of(Twitter::REST::Client)
        .to receive(:destroy_status)
        .with 'a tweet'
      expect_any_instance_of(Post).to receive :twitter_start!

      @post.twitter_change!

      expect(@post.reload.twitter_post_id).to eql nil
    end
  end

  describe 'twitter_end!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'creates a tweek with the short ending text and saves the ID' do
      tweet = Twitter::Tweet.new id: 100
      expect_any_instance_of(Twitter::REST::Client)
        .to receive(:update)
        .with(@post.short_ending_text)
        .and_return tweet

      @post.twitter_end!

      expect(@post.ending_twitter_post_id).to eql 100
    end
  end

  describe 'twitter_start!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'creates a tweet with the short text and saves the ID' do
      tweet = Twitter::Tweet.new id: 100
      expect_any_instance_of(Twitter::REST::Client)
        .to receive(:update)
        .with(@post.short_text)
        .and_return tweet

      @post.twitter_start!

      expect(@post.twitter_post_id).to eql 100
    end
  end
end
