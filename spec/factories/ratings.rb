FactoryGirl.define do
  factory :rating do
    user
    lesson

    clarity 2
    helpfulness 4
    comment "Not bad."
  end

end
