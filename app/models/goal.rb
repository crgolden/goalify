class Goal < ActiveRecord::Base

  include PgSearch

  belongs_to :user
  belongs_to :parent, class_name: 'Goal'

  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'
  has_many :subscriptions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :scores, through: :subscriptions

  accepts_nested_attributes_for :comments

  validates :title, presence: true

  pg_search_scope :search_title_and_text, against: {title: 'A', score: 'B', text: 'C'}

  def self.with_highest_score
    find_by score: maximum(:score)
  end

end
