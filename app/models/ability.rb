class Ability

include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, [Goal, User, Comment, Score, Subscription]
    if user.regular?
      can :create, [Goal, Comment, Subscription]
      can :manage, [Goal, Comment, Subscription, Token], user_id: user.id
      can :manage, User, id: user.id
      cannot :destroy, Goal
    elsif user.admin?
      can :manage, :all
    end
  end

end
