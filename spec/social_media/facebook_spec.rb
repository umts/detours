require 'rails_helper'

# In this file, rather than globally stubbing out Facebook API requests,
# we stub them out only in before blocks, so that the call will still be made
# in the actual specs (so we can explicitly MOCK those).

describe 'Facebook API requests' do
  describe 'facebook_change!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'deletes the existing post, clears the ID, and calls facebook_start!' do
      expect_any_instance_of(Koala::Facebook::API)
        .to receive(:delete_object)
        .with(@post.facebook_post_id)
      expect_any_instance_of(Post).to receive :facebook_start!

      @post.facebook_change!

      expect(@post.reload.facebook_post_id).to be nil
    end
  end

  describe 'facebook_end!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'creates a FB post with the ending text and saves the ID' \
       ' and comments on the original FB post' do
      fb_post = { id: '100' } # Koala just returns hash-ified JSON
      expect_any_instance_of(Koala::Facebook::API)
        .to receive(:put_wall_post)
        .with(@post.ending_text)
        .and_return fb_post
      expect_any_instance_of(Koala::Facebook::API)
        .to receive(:put_comment)
        .with @post.facebook_post_id, @post.ending_text

      @post.facebook_end!

      expect(@post.ending_facebook_post_id).to eql '100'
    end
  end

  describe 'facebook_start!' do
    before :each do
      stub_social_media_requests do
        @post = create :post
      end
    end
    it 'creates a FB post with the text and saves the ID' do
      fb_post = { id: '100' } # Koala just returns hash-ified JSON
      expect_any_instance_of(Koala::Facebook::API)
        .to receive(:put_wall_post)
        .with(@post.text)
        .and_return fb_post

      @post.facebook_start!

      expect(@post.facebook_post_id).to eql '100'
    end
  end

  describe 'self.update_facebook!' do
    it 'calls facebook_start! on current posts which have not been posted' do
      stub_social_media_requests do
        create :post, start_datetime: 1.minute.ago, end_datetime: 1.day.since,
                      facebook_post_id: nil
      end
      expect_any_instance_of(Post)
        .to receive(:facebook_start!)
        .and_return nil
      SocialMedia.update_facebook!
    end
    it "doesn't call facebook_start! on current posts which have been posted" do
      stub_social_media_requests do
        create :post, start_datetime: 1.minute.ago, end_datetime: 1.day.since,
                      facebook_post_id: 100
      end
      expect_any_instance_of(Post)
        .not_to receive :facebook_start!
      SocialMedia.update_facebook!
    end
    it 'calls facebook_end! on ended posts which have not been end posted' do
      stub_social_media_requests do
        create :post, start_datetime: 1.day.ago, end_datetime: 1.minute.ago,
                      ending_facebook_post_id: nil
      end
      expect_any_instance_of(Post)
        .to receive(:facebook_end!)
        .and_return nil
      SocialMedia.update_facebook!
    end
    it "doesn't call facebook_end! on ended posts which have been end posted" do
      stub_social_media_requests do
        create :post, start_datetime: 1.day.ago, end_datetime: 1.minute.ago,
                      ending_facebook_post_id: 100
      end
      expect_any_instance_of(Post)
        .not_to receive :facebook_end!
      SocialMedia.update_facebook!
    end
  end
end
