class SubmissionGrade < ActiveRecord::Base
  belongs_to :submission

  enum score: {
    does_not_meet_expectation: -1,
    meets_expectation: 0,
    exceeds_expectation: 1
  }

  validates :submission,
    presence: true

  validates :score,
    presence: true,
    inclusion: self.scores.keys

end
