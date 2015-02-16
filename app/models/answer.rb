class Answer < ActiveRecord::Base
  has_many :answer_comments
  belongs_to :user
  belongs_to :question, counter_cache: true

  validates :user, presence: true
  validates :question, presence: true
  validates :body, presence: true, length: { in: 10..10000 }

  def accepted?
    question.accepted_answer == self
  end

  def self.search(query)
    where("searchable @@ plainto_tsquery(?)", query)
  end
end
