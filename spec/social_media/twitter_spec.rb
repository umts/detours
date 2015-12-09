require 'rails_helper'

# In this file, rather than globally stubbing out Twitter API requests,
# we stub them out only in before blocks, so that the call will still be made
# in the actual specs (so we can explicitly MOCK those).

describe 'Twitter API requests' do
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

  describe 'self.update_twitter!' do
    it 'calls twitter_start! on current posts which have not been tweeted' do
      stub_social_media_requests do
        create :post, start_datetime: 1.minute.ago, end_datetime: 1.day.since,
                      twitter_post_id: nil
      end
      expect_any_instance_of(Post)
        .to receive(:twitter_start!)
        .and_return nil
      SocialMedia.update_twitter!
    end
    it "doesn't call twitter_start! on current posts which have been tweeted" do
      stub_social_media_requests do
        create :post, start_datetime: 1.minute.ago, end_datetime: 1.day.since,
                      twitter_post_id: 100
      end
      expect_any_instance_of(Post)
        .not_to receive :twitter_start!
      SocialMedia.update_twitter!
    end
    it 'calls twitter_end! on ended posts which have not been end tweeted' do
      stub_social_media_requests do
        create :post, start_datetime: 1.day.ago, end_datetime: 1.minute.ago,
                      ending_twitter_post_id: nil
      end
      expect_any_instance_of(Post)
        .to receive(:twitter_end!)
        .and_return nil
      SocialMedia.update_twitter!
    end
    it "doesn't call twitter_end! on ended posts which have been end tweeted" do
      stub_social_media_requests do
        create :post, start_datetime: 1.day.ago, end_datetime: 1.minute.ago,
                      ending_twitter_post_id: 100
      end
      expect_any_instance_of(Post)
        .not_to receive :twitter_end!
      SocialMedia.update_twitter!
    end
  end
end
