class Ability

include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, [Goal, User, Comment, Score, GoalsUsers]
    if user.regular?
      can :create, [Goal, Comment, GoalsUsers]
      can :manage, [Goal, Comment, GoalsUsers, Token], user_id: user.id
      can :manage, User, id: user.id
      cannot :destroy, [Goal, Comment]
    elsif user.admin?
      can :manage, :all
    end
  end

end
