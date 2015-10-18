class Comment < ActiveRecord::Base
  include Filterable

  belongs_to :goal
  belongs_to :user

  validates :body, presence: true
  validates :goal, presence: true
  validates :user, presence: true

  scope :goal_id, -> (goal_id) { where goal_id: goal_id }
  scope :user_id, -> (user_id) { where user_id: user_id }

end
