class Comment < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user

  validates :body, presence: true
  validates :goal, presence: true
  validates :user, presence: true
end
