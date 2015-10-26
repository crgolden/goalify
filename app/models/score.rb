class Score < ActiveRecord::Base

  belongs_to :subscription

  validates :value, presence: true

  after_create { update_goal_and_user_scores self.value }
  after_destroy { update_goal_and_user_scores -self.value }

  def update_goal_and_user_scores(value)
    goal = self.subscription.goal
    user = goal.user
    goal.update score: (goal.score += value)
    user.update score: (user.score += value)
  end

end
