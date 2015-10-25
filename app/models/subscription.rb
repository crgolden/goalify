class Subscription < ActiveRecord::Base

  include Filterable

  belongs_to :goal
  belongs_to :user

  has_many :scores, dependent: :destroy

  CREATED_VALUE = 50
  COMPLETED_VALUE = 100

  before_save {
    unless self.completed? || self.scores.find_by(value: COMPLETED_VALUE).nil?
      self.scores.find_by(value: COMPLETED_VALUE).destroy
    end }

  after_save {
    if self.completed?
      self.scores.create value: COMPLETED_VALUE
    else
      self.scores.create value: CREATED_VALUE
    end }

  scope :goal, -> (goal) { where goal: goal }
  scope :user, -> (user) { where user: user }

  def self.exists_for_goal_and_user?(goal, user)
    find_by goal: goal, user: user
  end

end
