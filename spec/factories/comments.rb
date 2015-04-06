FactoryGirl.define do
  factory :comment do
    user
    submission
    body "Needs more cow-bell."
  end
end
