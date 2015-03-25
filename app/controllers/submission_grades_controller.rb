class SubmissionGradesController < ApplicationController
  def create
    @submission = Submission.find(params[:submission_id])
    @grade = @submission.build_grade(grade_params)
    if @grade.save
      redirect_to submission_path(@submission),
        notice: 'Grade recorded.'

    else
      redirect_to submission_path(@submission),
        alert: 'Could not save grade.'
    end
  end

  protected
  def grade_params
    params.require(:grade).permit(:score, :comment)
  end
end
