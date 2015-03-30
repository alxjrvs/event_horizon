require 'rails_helper'

describe SubmissionFilter do
  before do
    @user = create(:user, username: 'monocle_lover')
    @past_user = create(:user, username: 'pug_addict')
    @fellow_user = create(:user, username: 'gamecube_guru')
    @admin = create :user, username: 'pickett_line', role: "admin"

    current_team = create(:team)
    past_team = create(:team)
    lesson = create(:lesson)

    @user.teams << current_team
    @fellow_user.teams << current_team
    @past_user.teams << past_team

    @my_submission = create(:submission, lesson: lesson, user: @user, public: true)
    @fellow_submission = create(:submission, lesson: lesson, user: @fellow_user, public: true)
    @past_submission = create(:submission, lesson: lesson, user: @past_user, public: true)

    @submissions = lesson.submissions
  end

  context "Student User" do
    before do
      filter = SubmissionFilter.new(@user, @submissions)
      @results = filter.viewable_submissions
    end

    it "returns public submissions for my cohort, and my own" do
      binding.pry
      expect(@results).to match_array [@my_submission, @fellow_submission]
    end
  end

  context "Admin User" do
    before do
      filter = SubmissionFilter.new(@admin, @submissions)
      @results = filter.viewable_submissions
    end

    it "returns all submissions" do
      expect(@results).to match_array [@my_submission, @fellow_submission, @past_submission]
    end
  end
end
