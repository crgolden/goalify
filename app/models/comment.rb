class Comment < ActiveRecord::Base

  include Filterable

  belongs_to :goal
  belongs_to :user

  validates :body, presence: true

  scope :goal, -> (goal) { where goal: goal }
  scope :user, -> (user) { where user: user }

end
