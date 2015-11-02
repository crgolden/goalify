class Score < ActiveRecord::Base

  CREATED_VALUE = 50
  COMPLETED_VALUE = 100

  belongs_to :goal, touch: true

  has_one :user, through: :goal

  validates :value, presence: true
  validates :description, presence: true

  after_create { update_goal_and_user_scores self.value }
  after_destroy { update_goal_and_user_scores -self.value }

  def self.created_value
    CREATED_VALUE
  end

  def self.completed_value
    COMPLETED_VALUE
  end

  def update_goal_and_user_scores(value)
    goal = self.goal
    user = goal.user
    goal.update score: (goal.score += value)
    user.update score: (user.score += value)
  end

end
