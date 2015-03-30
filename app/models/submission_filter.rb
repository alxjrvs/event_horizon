class SubmissionFilter

  attr_reader :user, :submissions

  def initialize(user, submissions)
    @user = user
    @submissions = submissions
  end

  def viewable_submissions
    return submissions if user.admin?
    return cohort_public_submissions if submissions.has_submission_from? user
    submissions.none
  end

  private

  def cohort_public_submissions
    personal_and_public_submissions.select do |submission|
      teams_id = submission.user.teams.pluck(&:id)
    end
  end

  def personal_and_public_submissions
    submissions.where("user_id = ? OR public = true", user.id)
  end

  def user_teams
    user.teams
  end

end
