FactoryGirl.define do
  factory :post do
    sequence(:text) { |n| "Post #{n}" }
    sequence :facebook_post_id
    sequence :twitter_post_id
  end
end
