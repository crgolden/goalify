class Score < ActiveRecord::Base

  include Filterable

  belongs_to :subscription

  CREATED_VALUE = 50
  COMPLETED_VALUE = 100

  validates :value, presence: true

  after_save { increase_totals }
  before_destroy { decrease_totals }

  scope :subscription, -> (subscription) { where subscription: subscription }
  scope :user, -> (user) { User.find(user).scores }
  scope :goal, -> (goal) { Goal.find(goal).scores }

  def increase_totals
    self.subscription.goal.update score: (self.subscription.goal.score += self.value)
    self.subscription.goal.user.update score: (self.subscription.goal.user.score += self.value)
  end

  def decrease_totals
    self.subscription.goal.update score: (self.subscription.goal.score -= self.value)
    self.subscription.goal.user.update score: (self.subscription.goal.user.score -= self.value)
  end

end
