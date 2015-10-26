class Subscription < ActiveRecord::Base

  belongs_to :goal
  belongs_to :user

  has_many :scores, dependent: :destroy

  CREATED_VALUE = 50
  COMPLETED_VALUE = 100

  after_create { self.scores.create value: CREATED_VALUE }
  after_update { self.scores.create value: COMPLETED_VALUE }

  def self.exists_for_goal_and_user?(goal, user)
    find_by goal: goal, user: user
  end

end
