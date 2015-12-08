FactoryGirl.define do
  factory :post do
    sequence(:text) { |n| "Post text #{n}" }
    sequence(:ending_text) { |n| "Post ending text #{n}" }
    sequence(:short_text) { |n| "Post short text #{n}" }
    sequence(:short_ending_text) { |n| "Post short ending text #{n}" }
    sequence :facebook_post_id
    sequence :twitter_post_id
  end
end
