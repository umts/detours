FactoryGirl.define do
  factory :route do
    sequence(:name) { |n| "Route #{n}" }
    sequence :number
    property Route::PROPERTIES.first
  end
end
