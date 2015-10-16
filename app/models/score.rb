class Score < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user

  validates :goal, presence: true
  validates :user, presence: true
  validates :value, presence: true

  def self.total_for_goal(goal)
    total = 0
    where(goal: goal).each do |score|
      total += score.value
    end
    total
  end

  def self.total_for_user(user)
    total = 0
    Goal.where(user: user).each do |goal|
      total += total_for_goal goal
    end
    total
  end

end
