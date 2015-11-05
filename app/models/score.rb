class Score < ActiveRecord::Base

  CREATED_VALUE = 100
  COMPLETED_VALUE = 500

  belongs_to :goal
  belongs_to :user

  validates :value, presence: true
  validates :description, presence: true

  after_create { update_score_values self.value }
  after_destroy { update_score_values -self.value }

  def self.created_value
    CREATED_VALUE
  end

  def self.completed_value
    COMPLETED_VALUE
  end

  def update_score_values(value)
    subscription = self.goal
    user = subscription.user
    subscription.update score: (subscription.score += value)
    user.update score: (user.score += value)
  end

end
