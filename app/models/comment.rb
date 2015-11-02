class Comment < ActiveRecord::Base

  belongs_to :goal, touch: true
  belongs_to :user, touch: true

  validates :body, presence: true

end
