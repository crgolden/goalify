class Goal < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, class_name: 'Goal'

  has_many :comments, dependent: :destroy
  has_many :steps, class_name: 'Goal', foreign_key: 'parent_id'

  validates :title, presence: true
  validates :user, presence: true
end
