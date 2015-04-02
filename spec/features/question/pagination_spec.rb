require 'rails_helper'

feature 'Question Pagination' do
  scenario 'Question Index page' do
    create(:question, title: "Not Visible", created_at: 1.day.ago)
    25.times do
      create(:question, title: "Question that can be seen")
    end

    visit questions_path

    expect(page).to_not have_content "Not Visible"
  end
end
