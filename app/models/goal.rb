class Goal < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Goal'

  has_many :comments, dependent: :destroy
  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'
  has_many :scores
  has_many :subscriptions

  validates :title, presence: true
  validates :user, presence: true

  scope :filter_by_title, lambda { |keyword| where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :recent, -> { order(:updated_at) }

  def self.search(params = {})
    goals = params[:id].present? ? Goal.where(id: params[:id]) : Goal.all
    goals = goals.filter_by_title(params[:title]) if params[:title].present?
    goals = goals.recent(params[:recent]) if params[:recent].present?
    goals
  end
end
