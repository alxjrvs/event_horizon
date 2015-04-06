FactoryGirl.define do
  factory :submission_grade do
    association :submission
    score :meets_expectation
  end
end
