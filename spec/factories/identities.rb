FactoryGirl.define do
  factory :identity do
    association :user, factory: :user_without_identity

    provider 'github'
    sequence(:uid) { |n| n.to_s }


    factory :github_identity

    factory :launch_pass_identity do
      provider 'launch_pass'
      sequence(:uid) { |n| n.to_s }
    end
  end
end
