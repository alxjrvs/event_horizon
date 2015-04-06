FactoryGirl.define do
  factory :calendar do
    sequence(:name) { |n| "Calendar #{n}" }
    sequence(:cid) { |n| "calendar-reference-email#{n}@gmail.com" }
  end
end
