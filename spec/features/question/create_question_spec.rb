require "rails_helper"

feature "creating a question" do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in_as(user)
  end

  scenario "submit a valid question" do
    visit new_question_path

    fill_in "Title", with: "What's for lunch?"
    fill_in "Body", with: "Please, no more Dumpling Cafe."

    click_button "Ask Question"

    expect(page).to have_content("Question saved.")

    expect(Question.count).to eq(1)
    expect(page).to have_content("What's for lunch?")
    expect(page).to have_content("Please, no more Dumpling Cafe.")
  end

  scenario "submit an invalid question" do
    visit new_question_path
    click_button "Ask Question"

    expect(page).to have_content("Failed to save question.")
    expect(page).to have_content("Title: can't be blank, is too short (minimum is 10 characters)")
    expect(page).to have_content("Body: can't be blank")
    expect(Question.count).to eq(0)
  end
end
