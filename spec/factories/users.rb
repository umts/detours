FactoryGirl.define do
  factory :user do
    first_name 'FirstName'
    last_name 'LastName'
    sequence(:spire) { |n| n.to_s.rjust(8, '0') + '@umass.edu' }
    sequence(:email) { |n| "user#{n}@umass.edu" }
  end
end
