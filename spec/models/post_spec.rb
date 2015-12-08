require 'rails_helper'

describe Post do
  before :each { stub_social_media_requests }

  describe 'current' do
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
    let :call do
      Post.current
    end
    it 'returns ongoing posts' do
      expect(call).not_to include @old_post
      expect(call).to include @current_post
      expect(call).not_to include @future_post
    end
    it 'returns posts with no start datetime ending after today' do
      no_start = create :post,
                        start_datetime: nil,
                        end_datetime: 1.day.since
      expect(call).to include no_start
    end
    it 'returns posts with no end datetime starting before today' do
      no_end = create :post,
                      start_datetime: 1.day.ago,
                      end_datetime: nil
      expect(call).to include no_end
    end
    it 'returns posts with no start datetime or end datetime' do
      no_start_or_end = create :post,
                               start_datetime: nil,
                               end_datetime: nil
      expect(call).to include no_start_or_end
    end
  end

  describe 'ended' do
    it 'returns posts ending in the past regardless of when they start'
    it 'does not return posts with no end datetime'
  end

  describe 'upcoming' do
    let :call do
      Post.upcoming
    end
    it 'returns posts starting in the future regardless of when they end' do
      current_post = create :post,
                            start_datetime: 1.minute.ago
      future_post = create :post,
                           start_datetime: 1.minute.since
      expect(call).to include future_post
      expect(call).not_to include current_post
    end
    it 'does not return posts with no start datetime' do
      post = create :post,
                    start_datetime: nil
      expect(call).not_to include post
    end
  end

  describe 'current?' do
    it 'returns true if post is ongoing'
    it 'returns true if post has no start datetime and ends after today'
    it 'returns true if post has no end datetime and starts before today'
    it 'returns true if post has no start or end datetime'
  end

  describe 'ended?' do
    it 'returns true if post ended in the past regardless of when it starts'
    it 'returns false if post has no end datetime'
  end

  describe 'route_numbers' do
    before :each do
      route_1 = create :route, number: '1'
      route_2 = create :route, number: '2'
      @post = create :post, routes: [route_1, route_2]
    end
    it 'returns comma-separated route numbers' do
      expect(@post.route_numbers).to eql '1, 2'
    end
  end
end
