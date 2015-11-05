class GoalsUsers < ActiveRecord::Base

  belongs_to :goal, class_name: 'Goal'
  belongs_to :user, class_name: 'User'

  after_create { Score.create value: Score.created_value, description: (self.user.name + ' subscribed to ' + self.goal.title), user: self.user, goal: self.goal }
  after_update { Score.create value: Score.completed_value, description: (self.user.name + ' completed ' + self.goal.title), user: self.user, goal: self.goal }
  before_destroy { Score.where(user: self.user, goal: self.goal).each { |score| score.destroy } }
end
