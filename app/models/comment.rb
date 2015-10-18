class Comment < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user

  validates :body, presence: true
  validates :goal, presence: true
  validates :user, presence: true

  scope :filter_by_body, lambda { |keyword| where 'lower(body) LIKE ?', "%#{keyword.downcase}%" }
  scope :filter_by_user_id, lambda { |id| where user_id: id }
  scope :filter_by_goal_id, lambda { |id| where goal_id: id }
  scope :recent, -> { order :updated_at }

  def self.search(params = {})
    comments = params[:id].present? ? Comment.where(id: params[:id]) : Comment.all
    comments = comments.filter_by_body(params[:body]) if params[:body].present?
    comments = comments.filter_by_user_id(params[:user_id]) if params[:user_id].present?
    comments = comments.filter_by_goal_id(params[:goal_id]) if params[:goal_id].present?
    comments = comments.recent(params[:recent]) if params[:recent].present?
    comments
  end

end
