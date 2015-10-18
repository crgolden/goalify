class Goal < ActiveRecord::Base
  include Filterable

  belongs_to :user
  belongs_to :parent, class_name: 'Goal'

  has_many :comments, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'
  has_many :subscriptions, dependent: :destroy

  accepts_nested_attributes_for :comments

  validates :title, presence: true
  validates :user, presence: true

  scope :filter_title, -> (title) { where 'lower(title) like ?', "%#{title.downcase}%" }
  scope :user_id, -> (user_id) { where user_id: user_id }
  scope :recent, -> { order :updated_at }

end
