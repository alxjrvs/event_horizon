class SubmissionGradesController < ApplicationController
  def create
    @submission = Submission.find(params[:submission_id])
    @grade = @submission.new_grade(params[:grade])
    if @grade.save
      redirect_to submission_path(@submission),
        notice: 'Grade recorded.'

    else
      redirect_to submission_path(@submission),
        alert: 'Could not save grade.'
    end
  end
end
