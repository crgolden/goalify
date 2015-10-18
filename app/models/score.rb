class Score < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user

  validates :goal, presence: true
  validates :user, presence: true
  validates :value, presence: true

  scope :filter_by_value, lambda { |id| where 'value LIKE ?', "%#{id}%" }
  scope :filter_by_user_id, lambda { |id| where user_id: id }
  scope :filter_by_goal_id, lambda { |id| where goal_id: id }
  scope :recent, -> { order :updated_at }

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

  def self.search(params = {})
    scores = params[:id].present? ? Score.where(id: params[:id]) : Score.all
    scores = scores.filter_by_value(params[:value]) if params[:value].present?
    scores = scores.filter_by_user_id(params[:user_id]) if params[:user_id].present?
    scores = scores.filter_by_goal_id(params[:goal_id]) if params[:goal_id].present?
    scores
  end

end
