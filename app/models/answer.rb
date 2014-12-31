class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user, presence: true
  validates :question, presence: true
  validates :body, presence: true, length: { in: 10..10000 }

  def accepted?
    question.accepted_answer == self
  end
end
