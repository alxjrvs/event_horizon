FactoryGirl.define do
  factory :announcement do
    sequence(:title) { |n| "Announcement #{n}" }
    description "Here is a very nice description for a very nice announcement.
      The students shall cheer and rejoice when they see it."
    team
  end
end
