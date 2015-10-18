class Subscription < ActiveRecord::Base
  include Filterable

  belongs_to :goal
  belongs_to :user

  CREATED_VALUE = 50
  COMPLETED_VALUE = 100

  validates :goal, presence: true
  validates :user, presence: true
  before_save { remove_score_from_goal(COMPLETED_VALUE) unless self.completed? }
  before_save { self.completed? ? add_score_to_goal(COMPLETED_VALUE) : add_score_to_goal(CREATED_VALUE) }
  before_destroy { remove_score_from_goal COMPLETED_VALUE }
  before_destroy { remove_score_from_goal CREATED_VALUE }

  scope :goal_id, -> (goal_id) { where goal_id: goal_id }
  scope :user_id, -> (user_id) { where user_id: user_id }

  def add_score_to_goal(value)
    attr = {user: self.user, value: value}
    unless self.goal.scores.find_by attr
      self.goal.scores.create attr
    end
  end

  def remove_score_from_goal(value)
    attr = {user: self.user, value: value}
    if self.goal.scores.find_by attr
      self.goal.scores.find_by(attr).destroy
    end
  end

  def self.exists_for_goal_and_user?(goal, user)
    find_by goal: goal, user: user
  end

end
