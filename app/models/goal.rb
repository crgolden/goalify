class Goal < ActiveRecord::Base

  include PgSearch
  include Filterable

  belongs_to :user
  belongs_to :parent, class_name: 'Goal'

  has_many :comments, dependent: :destroy
  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :comments

  validates :title, presence: true

  scope :user, -> (user) { where user: user }
  scope :recent, -> { order :updated_at }

  pg_search_scope :search_title_and_text, against: {title: 'A', text: 'B'}

  def self.with_highest_score
    find_by score: maximum(:score)
  end

  def scores
    goal_scores = []
    self.subscriptions.each do |subscription|
      subscription.scores.each do |score|
        goal_scores << score
      end
    end
    Kaminari.paginate_array goal_scores
  end

end
