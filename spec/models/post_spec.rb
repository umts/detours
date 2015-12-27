require 'rails_helper'

describe Post do
  before(:each) { stub_social_media_requests! }

  describe 'Post.current' do
    before :each do
      @old_post = create :post,
                         start_datetime: 2.weeks.ago,
                         end_datetime: 1.day.ago
      @current_post = create :post,
                             start_datetime: 1.minute.ago,
                             end_datetime: 1.minute.since
      @future_post = create :post,
                            start_datetime: 1.day.since,
                            end_datetime: 2.weeks.since
      @no_start = create :post,
                         start_datetime: nil,
                         end_datetime: 1.day.since
      @no_end = create :post,
                       start_datetime: 1.day.ago,
                       end_datetime: nil
      @no_start_or_end = create :post,
                                start_datetime: nil,
                                end_datetime: nil
    end
    subject { Post.current }
    it { is_expected.not_to include @old_post, @future_post }
    it { is_expected.to include @current_post }
    it { is_expected.to include @no_start, @no_end, @no_start_or_end }
  end

  describe 'ended' do
    before :each do
      @current_post = create :post,
                             end_datetime: 1.minute.since
      @past_post = create :post,
                          end_datetime: 1.minute.ago
      @no_end = create :post,
                       end_datetime: nil
    end
    subject { Post.ended }
    it { is_expected.to include @past_post }
    it { is_expected.not_to include @current_post, @no_end }
  end

  describe 'upcoming' do
    before :each do
      @current_post = create :post,
                             start_datetime: 1.minute.ago
      @future_post = create :post,
                            start_datetime: 1.minute.since
      @no_start = create :post,
                         start_datetime: nil
    end
    subject { Post.upcoming }
    it { is_expected.to include @future_post }
    it { is_expected.not_to include @current_post, @no_start }
  end

  describe 'current?' do
    before :each do
      @old_post = create :post,
                         start_datetime: 2.weeks.ago,
                         end_datetime: 1.day.ago
      @current_post = create :post,
                             start_datetime: 1.minute.ago,
                             end_datetime: 1.minute.since
      @future_post = create :post,
                            start_datetime: 1.day.since,
                            end_datetime: 2.weeks.since
    end
    it 'returns true if post is ongoing' do
      expect(@old_post).not_to be_current
      expect(@current_post).to be_current
      expect(@future_post).not_to be_current
    end
    it 'returns true if post has no start datetime and ends after today' do
      no_start = create :post,
                        start_datetime: nil,
                        end_datetime: 1.day.since
      expect(no_start).to be_current
    end
    it 'returns true if post has no end datetime and starts before today' do
      no_end = create :post,
                      start_datetime: 1.day.ago,
                      end_datetime: nil
      expect(no_end).to be_current
    end
    it 'returns true if post has no start or end datetime' do
      no_start_or_end = create :post,
                               start_datetime: nil,
                               end_datetime: nil
      expect(no_start_or_end).to be_current
    end
  end

  describe 'has_ended?' do
    it 'returns true if post ended in the past regardless of when it starts' do
      current_post = create :post,
                            end_datetime: 1.minute.since
      past_post = create :post,
                         end_datetime: 1.minute.ago
      expect(past_post).to have_ended
      expect(current_post).not_to have_ended
    end
    it 'returns false if post has no end datetime' do
      post = create :post,
                    end_datetime: nil
      expect(post).not_to have_ended
    end
  end

  describe 'route_numbers' do
    let(:route_1) { create :route, number: '1' }
    let(:route_2) { create :route, number: '2' }
    let(:post) { create :post, routes: [route_1, route_2] }
    it 'returns comma-separated route numbers' do
      expect(post.route_numbers).to eql '1, 2'
    end
  end

  describe 'self.json' do # XML follows the same format
    before :each do
      @route = create :route
      @post = create :post, routes: [@route]
    end
    let :call do
      JSON.parse Post.json
    end
    it 'includes current posts' do
      expect(Post).to receive :current
      Post.json # don't parse here since we mock
    end
    it 'includes post text' do
      post = call.first
      expect(post.fetch 'text').to eql @post.text
    end
    it 'excludes social media IDs from posts' do
      post = call.first
      expect(post).not_to have_key 'facebook_post_id'
      expect(post).not_to have_key 'twitter_post_id'
      expect(post).not_to have_key 'ending_facebook_post_id'
      expect(post).not_to have_key 'ending_twitter_post_id'
    end
    it 'includes route name, number, and property' do
      route = call.first.fetch('routes').first
      expect(route.fetch 'name').to eql @route.name
      expect(route.fetch 'number').to eql @route.number
      expect(route.fetch 'property').to eql @route.property
    end
    it 'includes posts with no routes' do
      @post.update routes: []
      post = call.first
      expect(post.fetch 'text').to eql @post.text
    end
  end
end
