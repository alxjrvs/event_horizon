require 'rails_helper'

feature 'grade submission', %Q{
  As an administrative submission reviewer
  I want to "grade" systems checks
  So that Launchers have clarity as to where they stand
} do
  # Acceptance Criteria;
  #
  # * I can qualify a submission as not meeting expectation, meeting expectation, or exceeding expectation
  # * Only the submission's author and admins can see that grade
  # * Only admins can designate a grade
  # * A grade cannot be changed once issued

  let(:lesson) { FactoryGirl.create(:lesson) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:submission) do
    FactoryGirl.create(:submission, lesson: lesson, user: user)
  end

  scenario 'admin sees options on submission quality' do
    sign_in_as(admin)

    visit submission_path(submission)

    expect(page).to have_selector('#grade_comment')

    choose "Meets expectation."
    fill_in "Grade comments", with: "Good job!"
    click_button "Submit Grade"

    expect(page).to have_content("Grade recorded.")

  end

  scenario 'non-admin does not see options on submission quality' do
    sign_in_as(user)

    visit submission_path(submission)

    expect(page).to_not have_content "Does not meet expectations."
  end

  scenario 'admin cannot update existing grade' do
    submission
    FactoryGirl.create(:submission_grade, submission: submission)

    sign_in_as(admin)

    visit submission_path(submission)

    expect(page).to_not have_selector('#grade_comment')
  end

  scenario 'admin can see grade' do
    sign_in_as(admin)
    grade = FactoryGirl.create(:submission_grade, submission: submission)

    visit submission_path(submission)

    expect(page).to have_content(grade.score.humanize)
  end

  scenario 'submission author can see grade' do
    sign_in_as(user)
    grade = FactoryGirl.create(:submission_grade, submission: submission)

    visit submission_path(submission)

    expect(page).to have_content(grade.score.humanize)
  end

  scenario 'non-admin, non-submission author cannot see grade' do
    submission.public = true
    submission.save!

    other_user = FactoryGirl.create(:user)
    FactoryGirl.create(:submission, lesson: lesson, user: other_user)
    sign_in_as(other_user)

    grade = FactoryGirl.create(:submission_grade, submission: submission)

    visit submission_path(submission)

    expect(page).to_not have_content(grade.score.humanize)
  end
end
