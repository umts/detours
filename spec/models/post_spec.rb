require 'rails_helper'

describe Post do
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
    it 'returns only ongoing posts' do
      expect(call).not_to include @old_post
      expect(call).to include @current_post
      expect(call).not_to include @future_post
    end
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
