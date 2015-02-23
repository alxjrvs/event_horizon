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

  scenario 'admin sees options on submission quality and can grade' do
    sign_in_as(admin)

    visit submission_path(submission)

    expect(page).to have_content "Does not meet expectations."
    expect(page).to have_content "Meets expectations."
    expect(page).to have_content "Exceeds expectations."

    save_and_open_page
    check "Meets expectations."
    fill_in "Grade comments", with: "Good job!"
    click "Submit Grade"

    expect(page).to have_content("Grade recorded.")
  end

  scenario 'non-admin does not see options on submission quality' do
    sign_in_as(user)

    visit submission_path(submission)

    expect(page).to_not have_content "Does not meet expectations."
  end



  scenario 'admin cannot update existing grade'
  scenario 'admin can see grade'
  scenario 'submission author can see grade'
  scenario 'non-admin, non-submission author cannot see grade'
  scenario 'admin can select not meeting expectation'
end
