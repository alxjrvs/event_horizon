FactoryGirl.define do
  factory :answer do
    question
    user
    sequence(:body) { |n| "This is definitely the right answer #{n}." }
  end
end
