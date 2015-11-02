class GoalsUsers < ActiveRecord::Base

  belongs_to :goal
  belongs_to :user

  after_create { self.goal.scores.create value: Score.created_value, description: (self.user.name + ' subscribed to ' + self.goal.title) }
  after_update { self.goal.scores.create value: Score.completed_value, description: (self.user.name + ' completed ' + self.goal.title) }
  after_destroy { self.goal.scores.each do |score|
    score.destroy
  end }

end
