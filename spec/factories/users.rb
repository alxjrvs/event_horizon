FactoryGirl.define do
  factory :user_without_identity, class: User do
    sequence(:username) { |n| "george_michael_#{n}" }
    sequence(:email) { |n| "gm#{n}@example.com" }
    first_name "George"
    sequence(:last_name) { |n| "Michael #{n}" }
    role "member"

    factory :user do
      factory :admin do
        role "admin"
      end

      factory :user_with_assignment_submission do
        after(:create) do |user|
          team_membership = create(:team_membership , user: user)
          assignment = create(:assignment, team: team_membership.team)
          create(:submission, lesson: assignment.lesson, user: user)
        end
      end

      ignore do
        calendar_args nil
      end

      factory :user_with_calendar do
        after(:create) do |user, evaluator|
          calendar = build(:calendar, evaluator.calendar_args)
          team = create(:team, calendar: calendar)
          create(:team_membership, team: team, user: user)
        end
      end

      factory :user_with_multiple_assignment_submissions do
        after(:create) do |user|
          team_membership = create(:team_membership , user: user)
          core = create(:assignment, team: team_membership.team)
          create(:assignment, required: false, team: team_membership.team)
          create(:submission, lesson: core.lesson, user: user)
        end
      end
    end
  end
end
