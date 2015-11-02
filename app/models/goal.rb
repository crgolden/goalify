class Goal < ActiveRecord::Base

  include PgSearch

  belongs_to :parent, class_name: 'Goal'
  belongs_to :user, touch: true

  has_many :comments, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'

  has_and_belongs_to_many :subscribers, class_name: 'User', touch: true

  accepts_nested_attributes_for :comments

  validates :title, presence: true

  pg_search_scope :search_title_and_text, against: {title: 'A', score: 'B', text: 'C'}

  def comments?
    self.comments.any?
  end

  def has_subscriber?(user)
    self.subscribers.include? user
  end

  def scores?
    self.scores.any?
  end

  def subscriptions?
    self.steps.any?
  end

  def subscribers?
    self.subscribers.any?
  end

  def self.with_highest_score
    find_by score: maximum(:score)
  end

end
