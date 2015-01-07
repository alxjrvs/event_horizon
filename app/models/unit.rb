class Unit < ActiveRecord::Base
  has_many :quizzes

  validates :name, presence: true
  validates :description, length: { maximum: 1000 }
end