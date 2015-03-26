class SubmissionGradesController < ApplicationController
  def create
    submission = Submission.find(params[:submission_id])
    grade = submission.build_grade(grade_params)
    
    notice_flash = grade.save ? success_flash : failure_flash
    redirect_to submission_path(submission), notice_flash
  end

  protected

  def grade_params
    params.require(:grade).permit(:score, :comment)
  end

  private

  def success_flash
    { notice: 'Grade recorded.' }
  end

  def failure_flash
    { alert: 'Could not save grade.' }
  end
end
