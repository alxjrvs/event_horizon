FactoryGirl.define do
  factory :assignment do
    team
    lesson
    due_on { DateTime.now + 1.day }
    required true
  end
end
