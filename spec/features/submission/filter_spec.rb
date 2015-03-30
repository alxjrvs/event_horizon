require "rails_helper"

feature "filtering submissions by user" do
  let(:lesson) { FactoryGirl.create(:lesson, type: "challenge") }

  context "as a user" do
    scenario "I see only submissions from students in my cohort" do
      user = create(:user, username: 'monocle_lover')
      past_user = create(:user, username: 'pug_addict')
      fellow_user = create(:user, username: 'gamecube_guru')

      current_team = create(:team)
      past_team = create(:team)
      lesson = create(:lesson)

      user.teams << current_team
      fellow_user.teams << current_team
      past_user.teams << past_team

      create(:submission, lesson: lesson, user: user, public: true)
      create(:submission, lesson: lesson, user: fellow_user, public: true)
      create(:submission, lesson: lesson, user: past_user, public: true)

      sign_in_as(user)
      visit lesson_submissions_path(lesson)

      expect(page).to have_content "monocle_lover"
      expect(page).to have_content "pug_addict"
      expect(page).not_to have_content "gamecube_guru"
    end
  end
end
